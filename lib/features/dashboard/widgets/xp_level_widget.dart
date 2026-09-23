import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class XpLevelWidget extends StatelessWidget {
  final int xp;

  const XpLevelWidget({super.key, required this.xp});

  int _getLevel(int xp) {
    final thresholds = AppConstants.levelThresholds;
    for (int i = thresholds.length - 1; i >= 0; i--) {
      if (xp >= thresholds[i]) return i + 1;
    }
    return 1;
  }

  String _getLevelName(int level) {
    final names = AppConstants.levelNames;
    if (level <= 0) return names[0];
    if (level > names.length) return names.last;
    return names[level - 1];
  }

  @override
  Widget build(BuildContext context) {
    final level = _getLevel(xp);
    final levelName = _getLevelName(level);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.xpGold.withValues(alpha: 0.08),
            AppColors.bgCard,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.xpGold.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star_outline, color: AppColors.xpGold, size: 18),
              const SizedBox(width: 6),
              Text(
                'LVL $level',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.xpGold,
                      letterSpacing: 1.5,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${xp.toString()} XP',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
          ),
          Text(
            levelName,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}
