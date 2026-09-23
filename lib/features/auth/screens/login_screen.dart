import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_providers.dart';
import '../../../core/constants/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/cyber_text_field.dart';
import '../../../core/widgets/cyber_button.dart';
import '../../../core/widgets/cyber_background.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await ref.read(authActionsProvider).signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
      if (mounted) {
        final needsOnboarding = ref.read(needsOnboardingProvider);
        if (needsOnboarding) {
          context.go(AppRoutes.onboarding);
        } else {
          context.go(AppRoutes.home);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_parseError(e.toString())),
            backgroundColor: AppColors.cyberRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _parseError(String error) {
    if (error.contains('Invalid login credentials')) {
      return 'Invalid email or password. Please try again.';
    }
    if (error.contains('Email not confirmed')) {
      return 'Please confirm your email before logging in.';
    }
    return 'Login failed. Please check your connection and try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CyberBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  // Logo
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.cyberCyan.withOpacity(0.4),
                            width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cyberCyan.withOpacity(0.15),
                            blurRadius: 24,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: AppColors.cyberCyan,
                        size: 44,
                      ),
                    ),
                  ).animate().fadeIn(duration: 500.ms).scale(),
                  const SizedBox(height: 24),
                  Text(
                    'CYBERSPRINT 180',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.cyberCyan,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w900,
                        ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: 4),
                  Text(
                    'Welcome back, Defender',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 48),

                  // Email
                  CyberTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'you@college.edu',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!value.contains('@')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1),
                  const SizedBox(height: 16),

                  // Password
                  CyberTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: '••••••••',
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),
                  const SizedBox(height: 12),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push(AppRoutes.forgotPassword),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: AppColors.cyberCyan),
                      ),
                    ),
                  ).animate().fadeIn(delay: 450.ms),
                  const SizedBox(height: 24),

                  // Login button
                  CyberButton(
                    label: 'ACCESS SYSTEM',
                    icon: Icons.login,
                    isLoading: _isLoading,
                    onPressed: _signIn,
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
                  const SizedBox(height: 24),

                  // Divider
                  Row(
                    children: [
                      const Expanded(
                          child: Divider(color: AppColors.borderColor)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'NEW TO CYBERSPRINT?',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.textHint,
                                    letterSpacing: 1,
                                  ),
                        ),
                      ),
                      const Expanded(
                          child: Divider(color: AppColors.borderColor)),
                    ],
                  ).animate().fadeIn(delay: 550.ms),
                  const SizedBox(height: 16),

                  // Signup button
                  OutlinedButton.icon(
                    onPressed: () => context.push(AppRoutes.signup),
                    icon: const Icon(Icons.person_add_outlined),
                    label: const Text('CREATE ACCOUNT'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ).animate().fadeIn(delay: 600.ms),

                  const SizedBox(height: 32),

                  // Disclaimer
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.cyberOrange.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: AppColors.cyberOrange.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_outlined,
                            color: AppColors.cyberOrange, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Practice only on systems you own or have explicit permission to test.',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.cyberOrange),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 700.ms),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
