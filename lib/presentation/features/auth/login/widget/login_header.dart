import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/app_assets.dart';
import '../../../../../core/app_colors.dart';
import '../../../../../core/app_strings.dart';

class LoginHeader extends StatelessWidget {
  final bool isRegistering;

  const LoginHeader({super.key, this.isRegistering = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(AppAssets.logo, width: 100),
        const SizedBox(height: 24),
        Text(
          isRegistering ? 'Create Account' : AppStrings.welcomeBack,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          isRegistering
              ? 'Enter your details to create an account'
              : '${AppStrings.enterEmailPrompt} and password',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
