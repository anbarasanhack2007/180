import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/cyber_background.dart';

class StatGrid extends StatelessWidget {
  final int completedDays;
  final int studyHours;

  const StatGrid({
    super.key,
    required this.completedDays,
    required this.studyHours,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.0,
      children: [
        StatCard(
          label: 'Days Done',
          value: '$completedDays / 180',
          icon: Icons.calendar_today_outlined,
          color: AppColors.cyberCyan,
        ),
        StatCard(
          label: 'Study Hours',
          value: '${studyHours}h',
          icon: Icons.timer_outlined,
          color: AppColors.cyberBlue,
        ),
        StatCard(
          label: 'Completion',
          value: '${(completedDays / 180 * 100).toStringAsFixed(0)}%',
          icon: Icons.pie_chart_outline,
          color: AppColors.cyberPurple,
        ),
        StatCard(
          label: 'Remaining',
          value: '${180 - completedDays} days',
          icon: Icons.hourglass_empty,
          color: AppColors.cyberOrange,
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
