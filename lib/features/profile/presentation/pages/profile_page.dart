import 'package:flutter/material.dart';
import 'package:video_editor_demo/core/constants/app_strings.dart';
import 'package:video_editor_demo/core/theme/app_colors.dart';
import 'package:video_editor_demo/core/theme/app_text_styles.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(AppStrings.profile),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            Navigator.of(context).pushNamed('/settings');
          },
        ),
      ],
    ),
    body: const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: 50, color: AppColors.white),
          ),
          SizedBox(height: 24),
          Text(
            'User Profile',
            style: AppTextStyles.h3,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Manage your profile and account settings.',
            style: AppTextStyles.body1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
