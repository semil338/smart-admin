import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double height;
  final String text;
  final Color color;
  final Color textColor;
  final double fontSize;

  const SignInButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.height = 50,
    required this.color,
    this.textColor = Colors.white,
    this.fontSize = 1.1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(20)),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          textScaleFactor: fontSize,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
