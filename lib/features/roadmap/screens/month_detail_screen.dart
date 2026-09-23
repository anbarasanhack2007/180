import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../../data/repositories/curriculum_repository.dart';
import '../../../data/models/curriculum_models.dart';

final monthDetailProvider = FutureProvider.family<
    (MonthModel, List<WeekModel>, List<DailyTaskModel>), String>(
  (ref, monthId) async {
    final repo = ref.read(curriculumRepositoryProvider);
    final months = await repo.getMonths();
    final month = months.firstWhere((m) => m.id == monthId);
    final weeks = await repo.getWeeks(monthId: month.monthNumber);
    final days = await repo.getDaysByMonth(month.monthNumber);
    return (month, weeks, days);
  },
);

class MonthDetailScreen extends ConsumerWidget {
  final String monthId;
  const MonthDetailScreen({super.key, required this.monthId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(monthDetailProvider(monthId));

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CyberBackground(
        child: async.when(
          data: (data) {
            final (month, weeks, days) = data;
            final index = month.monthNumber - 1;
            final color =
                AppColors.monthColors[index % AppColors.monthColors.length];
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: AppColors.textPrimary),
                    onPressed: () => context.pop(),
                  ),
                  title: Text(
                    'MONTH ${month.monthNumber}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: color,
                          letterSpacing: 1,
                        ),
                  ),
                  centerTitle: true,
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Month header
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: color.withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              month.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: color,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Days ${month.daysStart}–${month.daysEnd} • ${month.totalDays} days',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              month.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.textPrimary),
                            ),
                            if (month.objectives.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(
                                'OBJECTIVES',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                        color: AppColors.textHint,
                                        letterSpacing: 1),
                              ),
                              const SizedBox(height: 8),
                              ...month.objectives.map((o) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Row(
                                      children: [
                                        Icon(Icons.check_circle,
                                            color: color, size: 14),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(o,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color:
                                                        AppColors.textSecondary,
                                                  )),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Weeks
                      Text(
                        'WEEKS',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.textHint,
                                  letterSpacing: 2,
                                ),
                      ),
                      const SizedBox(height: 10),
                      ...weeks.map((week) => _WeekTile(
                            week: week,
                            days: days
                                .where((d) => d.weekNumber == week.weekNumber)
                                .toList(),
                            color: color,
                          )),
                      const SizedBox(height: 32),
                    ]),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.cyberCyan)),
          error: (e, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: AppColors.cyberRed),
                const SizedBox(height: 8),
                Text('Failed to load month',
                    style: Theme.of(context).textTheme.bodyMedium),
                TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Go Back')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WeekTile extends StatelessWidget {
  final WeekModel week;
  final List<DailyTaskModel> days;
  final Color color;

  const _WeekTile(
      {required this.week, required this.days, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        childrenPadding: const EdgeInsets.only(bottom: 8),
        collapsedIconColor: AppColors.textHint,
        iconColor: color,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'W${week.weekNumber}',
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    week.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${days.length} days',
                    style: const TextStyle(
                      color: AppColors.textHint,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        children: days
            .map(
              (day) => ListTile(
                dense: true,
                leading: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: day.isExam
                        ? AppColors.cyberRed.withValues(alpha: 0.12)
                        : AppColors.bgElevated,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      '${day.dayNumber}',
                      style: TextStyle(
                        color: day.isExam
                            ? AppColors.cyberRed
                            : AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  day.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                  ),
                ),
                subtitle: Text(
                  '~${day.estimatedMinutes} min',
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 11,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: AppColors.textHint,
                  size: 16,
                ),
                onTap: () => context.push('/home/mission/${day.dayNumber}'),
              ),
            )
            .toList(),
      ),
    );
  }
}
