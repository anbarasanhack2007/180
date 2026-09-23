import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../domain/entities/progress.dart';

class StreakWidget extends StatelessWidget {
  final Streak streak;

  const StreakWidget({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.streakFire.withValues(alpha: 0.08),
            AppColors.bgCard,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.streakFire.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text(
                'STREAK',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.streakFire,
                      letterSpacing: 1.5,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${streak.currentStreak}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
          ),
          Text(
            'days • Best: ${streak.longestStreak}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}
