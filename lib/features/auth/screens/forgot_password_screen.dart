import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_providers.dart';
import '../../../core/constants/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/cyber_text_field.dart';
import '../../../core/widgets/cyber_button.dart';
import '../../../core/widgets/cyber_background.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await ref
          .read(authActionsProvider)
          .resetPassword(_emailController.text.trim());
      setState(() => _sent = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                const Text('Failed to send reset email. Please try again.'),
            backgroundColor: AppColors.cyberRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CyberBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  IconButton(
                    alignment: Alignment.centerLeft,
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 24),
                  if (_sent) ...[
                    const Icon(Icons.check_circle_outline,
                        color: AppColors.cyberGreen, size: 72),
                    const SizedBox(height: 24),
                    Text(
                      'Reset Link Sent!',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: AppColors.textPrimary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Check your email for a password reset link.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    OutlinedButton(
                      onPressed: () => context.go(AppRoutes.login),
                      child: const Text('Back to Login'),
                    ),
                  ] else ...[
                    Text(
                      'Reset Password',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your email and we\'ll send you a reset link.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 40),
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
                    ),
                    const SizedBox(height: 32),
                    CyberButton(
                      label: 'SEND RESET LINK',
                      icon: Icons.send_outlined,
                      isLoading: _isLoading,
                      onPressed: _sendReset,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
