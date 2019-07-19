import 'package:flutter/material.dart';
import 'package:flutter_heritage/view_state.dart';

class HeaderContent extends StatelessWidget {
  final double iconSize;
  final double fontSize;
  final double textPadding;

  const HeaderContent({
    Key key,
    this.iconSize,
    this.fontSize,
    this.textPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 2.0,
            height: 50.0,
            color: Colors.transparent,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              width: 16.0,
              height: 1.0,
              color: Colors.grey[700],
            ),
          ),
          Image.asset(
            'assets/img/sunny.png',
            width: iconSize,
            height: iconSize,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.only(left: textPadding),
            child: Text(
              'Malaysia',
              style: TextStyle(
                color: Colors.black,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Header extends StatefulWidget {
  final ViewState viewState;
  final double smallFontSize;
  final double largeFontSize;
  final double smallIconSize;
  final double largeIconSize;

  const Header({
    Key key,
    this.viewState,
    this.smallFontSize = 20.0,
    this.largeFontSize = 32.0,
    this.smallIconSize = 24.0,
    this.largeIconSize = 0.0,
  }) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _fontSizeTween;
  Animation<double> _iconSizeTween;
  Animation<double> _paddingSizeTween;

  double fontSize;
  double iconSize;
  double paddingSize;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 330),
    )..addListener(() {
        setState(() {
          fontSize = _fontSizeTween.value;
          iconSize = _iconSizeTween.value;
          paddingSize = _paddingSizeTween.value;
        });
      });

    switch (widget.viewState) {
      case ViewState.enlarge:
        _fontSizeTween = Tween<double>(
          begin: widget.smallFontSize,
          end: widget.largeFontSize,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

        _iconSizeTween = Tween<double>(
          begin: widget.smallIconSize,
          end: widget.largeIconSize,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

        _paddingSizeTween = Tween<double>(
          begin: 8.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

        _animationController.forward(from: 0.0);
        break;

      case ViewState.enlarged:
        fontSize = widget.largeFontSize;
        iconSize = widget.largeIconSize;
        paddingSize = 0.0;
        break;

      case ViewState.shrink:
        _fontSizeTween = Tween<double>(
          begin: widget.largeFontSize,
          end: widget.smallFontSize,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

        _iconSizeTween = Tween<double>(
          begin: widget.largeIconSize,
          end: widget.smallIconSize,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

        _paddingSizeTween = Tween<double>(
          begin: 0.0,
          end: 8.0,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

        _animationController.forward(from: 0.0);
        break;

      case ViewState.shrunk:
        fontSize = widget.smallFontSize;
        iconSize = widget.smallIconSize;
        paddingSize = 8.0;
        break;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HeaderContent(
      iconSize: iconSize,
      fontSize: fontSize,
      textPadding: paddingSize,
    );
  }
}
