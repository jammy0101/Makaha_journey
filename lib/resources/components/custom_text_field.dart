import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0), // vertical spacing
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        textCapitalization: TextCapitalization.words,
        keyboardType: TextInputType.text,
        style: TextStyle(color: theme.colorScheme.onSurface),
       // style: const TextStyle(fontSize: 16, color: Colors.black),
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 19),
            border: OutlineInputBorder(

            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )
        ),
        validator: validator,
      ),
    );
  }
}