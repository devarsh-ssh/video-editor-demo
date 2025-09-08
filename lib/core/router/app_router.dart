import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_editor_demo/features/home/presentation/pages/home_page.dart';
import 'package:video_editor_demo/features/profile/presentation/pages/profile_page.dart';
import 'package:video_editor_demo/features/settings/presentation/pages/settings_page.dart';
import 'package:video_editor_demo/features/splash/presentation/pages/splash_page.dart';
import 'package:video_editor_demo/features/video_editor/presentation/pages/video_editor_page.dart';

// ignore: avoid_classes_with_only_static_members
class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String editor = '/editor';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: editor,
        name: 'editor',
        builder: (context, state) {
          final uri = state.uri;
          final sourcePath = uri.queryParameters['path'];
          return VideoEditorPage(videoPath: sourcePath);
        },
      ),
    ],
    errorBuilder:
        (context, state) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Page not found',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'The page you are looking for does not exist.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go(home),
                  child: const Text('Go Home'),
                ),
              ],
            ),
          ),
        ),
  );
}
