// lib/features/auth/presentation/widgets/auth_header.dart

import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart'; // Assuming app_constants.dart has appLogoPath

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // App Logo (optional, can be an image asset)
        Image.asset(
          AppConstants.appLogoPath, // Path to your app logo asset
          height: 100,
          width: 100,
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30), // Space before the form fields
      ],
    );
  }
}
