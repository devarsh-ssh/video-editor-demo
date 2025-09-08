import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.home),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.of(context).pushNamed('/profile');
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_rounded,
              size: 80,
              color: AppColors.primary,
            ),
            SizedBox(height: 24),
            Text(
              'Welcome to Video Editor Pro!',
              style: AppTextStyles.h3,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Start creating amazing videos with our professional tools.',
              style: AppTextStyles.body1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final picker = ImagePicker();
          final picked = await picker.pickVideo(
            source: ImageSource.gallery,
            maxDuration: const Duration(minutes: 1),
          );
          if (picked == null) return;
          if (!context.mounted) return;
          final uri = Uri(
            path: '/editor',
            queryParameters: {'path': picked.path},
          );
          context.go(uri.toString());
        },
        icon: const Icon(Icons.file_upload_outlined),
        label: const Text(AppStrings.importVideo),
      ),
    );
  }
}
