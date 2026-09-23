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

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await ref.read(authActionsProvider).signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            fullName: _nameController.text.trim(),
          );
      if (mounted) context.go(AppRoutes.onboarding);
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
    if (error.contains('already registered')) {
      return 'This email is already registered. Try logging in.';
    }
    if (error.contains('Password should be')) {
      return 'Password must be at least 6 characters.';
    }
    return 'Signup failed. Please check your connection and try again.';
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
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Begin Your\nCyber Journey',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 8),
                  Text(
                    'Create your CyberSprint 180 account',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ).animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: 40),

                  CyberTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    hint: 'Your name',
                    prefixIcon: Icons.person_outline,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Name is required' : null,
                  ).animate().fadeIn(delay: 150.ms),
                  const SizedBox(height: 16),

                  CyberTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'you@college.edu',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Email is required';
                      if (!v.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 16),

                  CyberTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Min 6 characters',
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
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Password is required';
                      if (v.length < 6) {
                        return 'Must be at least 6 characters';
                      }
                      return null;
                    },
                  ).animate().fadeIn(delay: 250.ms),
                  const SizedBox(height: 16),

                  CyberTextField(
                    controller: _confirmController,
                    label: 'Confirm Password',
                    hint: 'Repeat password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscureConfirm,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Please confirm password';
                      }
                      if (v != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 32),

                  CyberButton(
                    label: 'INITIALIZE SYSTEM',
                    icon: Icons.rocket_launch_outlined,
                    isLoading: _isLoading,
                    onPressed: _signUp,
                  ).animate().fadeIn(delay: 350.ms),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text(
                          'Log In',
                          style: TextStyle(color: AppColors.cyberCyan),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 400.ms),
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
