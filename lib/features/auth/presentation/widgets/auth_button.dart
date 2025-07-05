// lib/features/auth/presentation/widgets/auth_button.dart

import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const AuthButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Make the button take full width
      height: 50, // Fixed height for consistency
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed, // Disable button when loading
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor, // Use primary color from theme
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
          ),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white, // White spinner when loading
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text
                ),
              ),
      ),
    );
  }
}
