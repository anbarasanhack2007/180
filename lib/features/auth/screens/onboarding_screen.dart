import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_providers.dart';
import '../../../core/constants/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/cyber_button.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../../core/widgets/cyber_text_field.dart';
import '../../../domain/entities/user_profile.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  // Form data
  final _collegeController = TextEditingController();
  final _degreeController = TextEditingController();
  int _studyYear = 2;
  String _cyberLevel = 'Beginner';
  int _dailyGoalMinutes = 120;

  final List<String> _levels = [
    'Complete Beginner',
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  final List<int> _goals = [60, 90, 120, 180, 240];

  @override
  void dispose() {
    _pageController.dispose();
    _collegeController.dispose();
    _degreeController.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    setState(() => _isLoading = true);
    try {
      final current =
          ref.read(currentProfileProvider).valueOrNull;
      if (current == null) return;

      final updated = current.copyWith(
        college: _collegeController.text.trim(),
        degree: _degreeController.text.trim(),
        studyYear: _studyYear,
        cybersecurityLevel: _cyberLevel,
        dailyGoalMinutes: _dailyGoalMinutes,
        updatedAt: DateTime.now(),
      );

      await ref
          .read(currentProfileProvider.notifier)
          .updateProfile(updated);

      if (mounted) context.go(AppRoutes.home);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: ${e.toString().split(']').last}'),
            backgroundColor: AppColors.cyberRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _next() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _complete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CyberBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  children: [
                    const Icon(Icons.shield_outlined,
                        color: AppColors.cyberCyan, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'CYBERSPRINT 180',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.cyberCyan,
                            letterSpacing: 2,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      'Step ${_currentPage + 1} of 3',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),

              // Step indicators
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: List.generate(3, (index) {
                    return Expanded(
                      child: Container(
                        height: 3,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: index <= _currentPage
                              ? AppColors.cyberCyan
                              : AppColors.borderColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (page) =>
                      setState(() => _currentPage = page),
                  children: [
                    _buildPage1(),
                    _buildPage2(),
                    _buildPage3(),
                  ],
                ),
              ),

              // Navigation
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: CyberButton(
                  label: _currentPage < 2 ? 'CONTINUE' : 'START JOURNEY 🚀',
                  icon: _currentPage < 2 ? Icons.arrow_forward : Icons.rocket_launch,
                  isLoading: _isLoading,
                  onPressed: _next,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tell us about\nyour education',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
          ).animate().fadeIn(),
          const SizedBox(height: 8),
          Text(
            'We\'ll personalize your 180-day journey',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 40),
          CyberTextField(
            controller: _collegeController,
            label: 'College / University',
            hint: 'e.g. IIT Madras',
            prefixIcon: Icons.school_outlined,
          ),
          const SizedBox(height: 16),
          CyberTextField(
            controller: _degreeController,
            label: 'Degree',
            hint: 'e.g. B.Tech Cybersecurity',
            prefixIcon: Icons.bookmark_outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Current Year',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [1, 2, 3, 4].map((year) {
              return ChoiceChip(
                label: Text('Year $year'),
                selected: _studyYear == year,
                onSelected: (selected) {
                  if (selected) setState(() => _studyYear = year);
                },
                selectedColor: AppColors.cyberCyan.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: _studyYear == year
                      ? AppColors.cyberCyan
                      : AppColors.textSecondary,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your current\ncybersecurity level?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
          ).animate().fadeIn(),
          const SizedBox(height: 32),
          ..._levels.map((level) {
            final selected = _cyberLevel == level;
            return GestureDetector(
              onTap: () => setState(() => _cyberLevel = level),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.cyberCyan.withOpacity(0.1)
                      : AppColors.bgCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected
                        ? AppColors.cyberCyan
                        : AppColors.borderColor,
                    width: selected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      selected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: selected
                          ? AppColors.cyberCyan
                          : AppColors.textHint,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      level,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            color: selected
                                ? AppColors.cyberCyan
                                : AppColors.textPrimary,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPage3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily study goal',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
          ).animate().fadeIn(),
          const SizedBox(height: 8),
          Text(
            'How many minutes per day can you commit?',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 32),
          ..._goals.map((minutes) {
            final selected = _dailyGoalMinutes == minutes;
            final hours = minutes ~/ 60;
            final mins = minutes % 60;
            final label = hours > 0
                ? (mins > 0 ? '${hours}h ${mins}m' : '${hours}h')
                : '${mins}m';
            return GestureDetector(
              onTap: () => setState(() => _dailyGoalMinutes = minutes),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.cyberCyan.withOpacity(0.1)
                      : AppColors.bgCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected
                        ? AppColors.cyberCyan
                        : AppColors.borderColor,
                    width: selected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: selected
                          ? AppColors.cyberCyan
                          : AppColors.textHint,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      label,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            color: selected
                                ? AppColors.cyberCyan
                                : AppColors.textPrimary,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                    ),
                    if (minutes == 120) ...[
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.cyberGreen.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'RECOMMENDED',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.cyberGreen,
                                    letterSpacing: 0.5,
                                  ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
