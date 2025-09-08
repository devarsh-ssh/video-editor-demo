import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_editor_demo/core/constants/app_strings.dart';
import 'package:video_editor_demo/core/router/app_router.dart';
import 'package:video_editor_demo/core/theme/app_colors.dart';
import 'package:video_editor_demo/core/theme/app_text_styles.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
  }

  Future<void> _startSplashSequence() async {
    // Start animations
    await _fadeController.forward();
    await _scaleController.forward();

    // Wait for animations to complete
    await Future<void>.delayed(const Duration(milliseconds: 2000));

    // Navigate to home page
    if (mounted) {
      context.go(AppRouter.home);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo/Icon with Animation
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder:
                  (context, child) => Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadowLight,
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.video_library_rounded,
                        size: 60,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
            ),

            const SizedBox(height: 40),

            // App Title with Fade Animation
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder:
                  (context, child) => Opacity(
                    opacity: _fadeAnimation.value,
                    child: Column(
                      children: [
                        Text(
                          AppStrings.splashTitle,
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 16),

                        Text(
                          AppStrings.splashSubtitle,
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
            ),

            const SizedBox(height: 60),

            // Loading Indicator
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder:
                  (context, child) => Opacity(
                    opacity: _fadeAnimation.value,
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
                        strokeWidth: 3,
                      ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    ),
  );
}
