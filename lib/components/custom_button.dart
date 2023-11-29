import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double? width;
  final double height;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final double radius;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.height = 42.0,
    this.color = const Color.fromARGB(255, 255, 136, 0),
    this.textColor = Colors.white,
    this.borderColor = const Color.fromARGB(255, 255, 136, 0),
    this.radius = 8.6,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: borderColor,
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 240, 116, 0).withOpacity(0.86),
              offset: const Offset(3.0, 3.0),
              blurRadius: 4.0,
            )
          ],
        ),
        child: Text(text,style: TextStyle(color: textColor),),
      ),
    );
  }
}


