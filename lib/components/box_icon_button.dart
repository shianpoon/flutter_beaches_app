import 'package:flutter/material.dart';

class BoxIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color iconColor;
  final Color buttonColor;
  final double buttonSize;

  const BoxIconButton({
    Key key,
    @required this.onPressed,
    @required this.icon,
    this.iconColor = Colors.white,
    this.buttonColor = Colors.black,
    this.buttonSize = 60.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonSize,
      height: buttonSize,
      child: FlatButton(
        shape: BeveledRectangleBorder(),
        splashColor: Colors.white24,
        color: buttonColor,
        onPressed: onPressed,
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}
