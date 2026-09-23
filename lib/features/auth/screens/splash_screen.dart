import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_providers.dart';
import '../../../core/constants/app_routes.dart';
import '../../../app/theme/app_colors.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final isSignedIn = ref.read(authRepositoryProvider).isSignedIn;
    if (isSignedIn) {
      final needsOnboarding = ref.read(needsOnboardingProvider);
      if (needsOnboarding) {
        context.go(AppRoutes.onboarding);
      } else {
        context.go(AppRoutes.home);
      }
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF080E1A),
              Color(0xFF0D1626),
              Color(0xFF0A1020),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Cyber grid background
            CustomPaint(
              painter: _CyberGridPainter(),
              child: const SizedBox.expand(),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Shield icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.cyberCyan.withValues(alpha: 0.5),
                          width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cyberCyan.withValues(alpha: 0.2),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: AppColors.cyberCyan,
                      size: 56,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .scale(begin: const Offset(0.5, 0.5)),
                  const SizedBox(height: 32),
                  Text(
                    'CYBERSPRINT',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.cyberCyan,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 8,
                        ),
                  ).animate().fadeIn(delay: 300.ms, duration: 600.ms),
                  const SizedBox(height: 4),
                  Text(
                    '1 8 0',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 16,
                        ),
                  ).animate().fadeIn(delay: 500.ms, duration: 600.ms),
                  const SizedBox(height: 16),
                  Text(
                    '180 Days. One Skillset. A Cybersecurity Career.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 700.ms, duration: 600.ms),
                  const SizedBox(height: 64),
                  const SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.cyberCyan,
                    ),
                  ).animate().fadeIn(delay: 900.ms, duration: 400.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CyberGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x0800E5FF)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
