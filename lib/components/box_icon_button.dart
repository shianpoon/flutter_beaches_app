import 'package:flutter/material.dart';

class BoxIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color iconColor;
  final Color buttonColor;
  final double buttonSize;

  const BoxIconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.iconColor = Colors.white,
    this.buttonColor = Colors.black,
    this.buttonSize = 60.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonSize,
      height: buttonSize,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(BeveledRectangleBorder()),
          overlayColor: MaterialStateProperty.all(Colors.white24),
          backgroundColor: MaterialStateProperty.all(buttonColor),
        ),
        onPressed: onPressed,
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}
