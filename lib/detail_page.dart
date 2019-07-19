import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_heritage/components/box_icon_button.dart';
import 'package:flutter_heritage/components/header.dart';
import 'package:flutter_heritage/components/title.dart';
import 'package:flutter_heritage/data/destination_model.dart';
import 'package:flutter_heritage/view_state.dart';

enum SlideDirection { rightToLeft, leftToRight, sliding, none }

class DetailPage extends StatefulWidget {
  final List<DestinationModel> destinationList;
  final int selectedIndex;

  const DetailPage({
    Key key,
    this.destinationList,
    this.selectedIndex,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  int currentIndex = 0;
  int offstageIndex = 0;
  SlideDirection slideDirection = SlideDirection.none;
  ValueNotifier<SlideDirection> slideNotifier;

  AnimationController _slideLeftAnimation;
  Animation<Offset> heroSlide;
  Animation<Offset> offstageSlide;
  double contentSpacing;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.selectedIndex;

    slideNotifier = ValueNotifier(slideDirection)
      ..addListener(() {
        setState(() {
          animate();
        });
      });

    _slideLeftAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          updateContents();
        }
      });
  }

  @override
  void dispose() {
    _slideLeftAnimation.dispose();
    slideNotifier.dispose();
    super.dispose();
  }

  void animate() {
    switch (slideNotifier.value) {
      case SlideDirection.leftToRight:
        heroSlide = Tween<Offset>(
          begin: Offset(0.0, 0.0),
          end: Offset(contentSpacing, 0.0),
        ).animate(
          CurvedAnimation(
            parent: _slideLeftAnimation,
            curve: Curves.easeInOut,
          ),
        );

        offstageSlide = Tween<Offset>(
          begin: Offset(-contentSpacing, 0.0),
          end: Offset(0.0, 0.0),
        ).animate(
          CurvedAnimation(
            parent: _slideLeftAnimation,
            curve: Curves.easeInOut,
          ),
        );

        _slideLeftAnimation.forward(from: 0.0);
        break;
      case SlideDirection.rightToLeft:
        heroSlide = Tween<Offset>(
          begin: Offset(0.0, 0.0),
          end: Offset(-contentSpacing, 0.0),
        ).animate(
          CurvedAnimation(
            parent: _slideLeftAnimation,
            curve: Curves.easeInOut,
          ),
        );

        offstageSlide = Tween<Offset>(
          begin: Offset(contentSpacing, 0.0),
          end: Offset(0.0, 0.0),
        ).animate(
          CurvedAnimation(
            parent: _slideLeftAnimation,
            curve: Curves.easeInOut,
          ),
        );

        _slideLeftAnimation.forward(from: 0.0);
        break;
      default:
        break;
    }
  }

  void updateContents() {
    switch (slideNotifier.value) {
      case SlideDirection.leftToRight:
        currentIndex =
            (currentIndex - 1).clamp(0, widget.destinationList.length - 1);
        slideNotifier.value = SlideDirection.none;
        break;
      case SlideDirection.rightToLeft:
        currentIndex =
            (currentIndex + 1).clamp(0, widget.destinationList.length - 1);
        slideNotifier.value = SlideDirection.none;
        break;
      default:
        break;
    }
  }

  double dx({bool isHero = false}) {
    switch (slideNotifier.value) {
      case SlideDirection.leftToRight:
        return isHero ? heroSlide.value.dx : offstageSlide.value.dx;
      case SlideDirection.rightToLeft:
        return isHero ? heroSlide.value.dx : offstageSlide.value.dx;
      default:
        return isHero ? 0.0 : contentSpacing;
    }
  }

  void _onPrevPressed() {
    if (currentIndex == 0) {
      return;
    }
    offstageIndex = currentIndex - 1;
    slideNotifier.value = SlideDirection.leftToRight;
  }

  void _onNextPressed() {
    if (currentIndex == widget.destinationList.length - 1) {
      return;
    }
    offstageIndex = currentIndex + 1;
    slideNotifier.value = SlideDirection.rightToLeft;
  }

  @override
  Widget build(BuildContext context) {
    contentSpacing = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(true);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white10,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            DetailContent(
              isHero: true,
              destination: widget.destinationList[currentIndex],
              dx: dx(isHero: true),
            ),
            DetailContent(
              isHero: false,
              destination: widget.destinationList[
                  offstageIndex.clamp(0, widget.destinationList.length - 1)],
              dx: dx(isHero: false),
              initialDx: contentSpacing,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  BoxIconButton(
                    onPressed: _onPrevPressed,
                    icon: Icons.arrow_back_ios,
                    iconColor: Colors.white,
                    buttonColor: currentIndex < widget.destinationList.length &&
                            currentIndex != 0
                        ? Colors.black
                        : Colors.grey,
                    buttonSize: 70.0,
                  ),
                  BoxIconButton(
                    onPressed: _onNextPressed,
                    icon: Icons.arrow_forward_ios,
                    iconColor: Colors.white,
                    buttonColor: currentIndex < widget.destinationList.length &&
                            currentIndex != widget.destinationList.length - 1
                        ? Colors.black
                        : Colors.grey,
                    buttonSize: 70.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final bool isHero;
  final double dx;
  final double initialDx;
  final DestinationModel destination;

  const DetailContent({
    Key key,
    @required this.destination,
    this.isHero = false,
    this.dx = 0.0,
    this.initialDx = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxOffset = MediaQuery.of(context).size.width;

    return ListView(
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 380.0,
          ),
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: isHero
                    ? Hero(
                        tag: 'malaysia',
                        child: Header(
                          viewState: ViewState.shrunk,
                        ),
                      )
                    : Container(),
              ),
              Positioned(
                top: 50.0,
                left: dx * 1.5,
                child: Opacity(
                  opacity: isHero ? 1.0 - (dx.abs() / maxOffset) : 1.0,
                  child: Hero(
                    tag: isHero ? '${destination.id}-img' : 'img',
                    child: Image.asset(
                      destination.imgAssetsPath[0],
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 300.0,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20.0,
                right: MediaQuery.of(context).size.width * 0.1,
                child: Opacity(
                  opacity: isHero ? 1.0 - (dx.abs() / maxOffset) : 1.0,
                  child: Hero(
                    tag: isHero ? '${destination.id}-btn' : 'btn',
                    child: Transform(
                      transform: Matrix4.translationValues(dx, 0.0, 0.0),
                      child: BoxIconButton(
                        onPressed: () {},
                        icon: Icons.add,
                        iconColor: Colors.white,
                        buttonColor: Colors.black,
                        buttonSize: 60.0,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 280.0,
                left: dx * 1.4 + 16.0,
                child: FractionalTranslation(
                  translation: Offset(0.0, 0.5),
                  child: Opacity(
                    opacity: isHero ? 1.0 - (dx.abs() / maxOffset) : 1.0,
                    child: Hero(
                      tag: isHero ? '${destination.id}-title' : 'title',
                      child: DestinationTitle(
                        title: destination.title,
                        viewState: ViewState.enlarged,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(dx * 1.2, 0.0, 0.0),
          child: Opacity(
            opacity: isHero ? 1.0 - (dx.abs() / maxOffset) : 1.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 36.0,
                    top: 8.0,
                    bottom: 16.0,
                  ),
                  child: Text(
                    destination.description,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                ActionRows(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ActionRows extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.location_on,
            color: Colors.black,
            size: 24.0,
          ),
          SizedBox(
            width: 24.0,
          ),
          Icon(
            Icons.outlined_flag,
            color: Colors.black,
            size: 24.0,
          ),
          SizedBox(
            width: 24.0,
          ),
          Icon(
            Icons.label_outline,
            color: Colors.black,
            size: 24.0,
          ),
          SizedBox(
            width: 24.0,
          ),
          Text(
            'More',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          )
        ],
      ),
    );
  }
}
