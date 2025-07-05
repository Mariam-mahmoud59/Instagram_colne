// lib/features/auth/presentation/widgets/auth_form_field.dart

import 'package:flutter/material.dart';

class AuthFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const AuthFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none, // No border line
        ),
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Colors.grey[200], // Background color for the field
        contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
      ),
      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color), // Text color
    );
  }
}
