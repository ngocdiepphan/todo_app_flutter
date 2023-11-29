import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final double radius;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.icon,
    this.radius = 12.0,
    this.obscureText = false,
    
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 103, 105, 103),
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: TextField(
        
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.withOpacity(0.85),
          ),
          prefixIcon: icon == null
              ? null
              : Icon(
                  icon,
                  color: const Color.fromARGB(255, 103, 105, 103),
                ),
          prefixIconConstraints: const BoxConstraints(minWidth: 40.0),
        ),

      ),
    );
  }
}

