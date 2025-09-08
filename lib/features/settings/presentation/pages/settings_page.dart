import 'package:flutter/material.dart';
import 'package:video_editor_demo/core/constants/app_strings.dart';
import 'package:video_editor_demo/core/theme/app_colors.dart';
import 'package:video_editor_demo/core/theme/app_text_styles.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text(AppStrings.settings)),
    body: const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings_outlined, size: 80, color: AppColors.primary),
          SizedBox(height: 24),
          Text(
            'Settings',
            style: AppTextStyles.h3,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Customize your app experience.',
            style: AppTextStyles.body1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
