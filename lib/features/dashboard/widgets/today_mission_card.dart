import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/models/curriculum_models.dart';
import '../../../core/constants/app_constants.dart';

class TodayMissionCard extends StatelessWidget {
  final DailyTaskModel task;

  const TodayMissionCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final monthColor = AppColors.monthColors[
        (task.monthNumber - 1).clamp(0, AppColors.monthColors.length - 1)];

    return GestureDetector(
      onTap: () => context.push('/home/mission/${task.dayNumber}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              monthColor.withOpacity(0.08),
              AppColors.bgCard,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: monthColor.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: monthColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'DAY ${task.dayNumber}',
                    style: TextStyle(
                      color: monthColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.bgElevated,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'MONTH ${task.monthNumber} • WEEK ${task.weekNumber}',
                    style: const TextStyle(
                      color: AppColors.textHint,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (task.isExam) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.cyberRed.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '📝 EXAM',
                      style: TextStyle(
                        color: AppColors.cyberRed,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
            Text(
              task.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              task.objective,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.timer_outlined,
                    color: AppColors.textHint, size: 14),
                const SizedBox(width: 4),
                Text(
                  '~${task.estimatedMinutes} min',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textHint,
                      ),
                ),
                const Spacer(),
                if (task.checklistItems.isNotEmpty) ...[
                  const Icon(Icons.checklist, color: AppColors.textHint, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '${task.checklistItems.length} tasks',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textHint,
                        ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
