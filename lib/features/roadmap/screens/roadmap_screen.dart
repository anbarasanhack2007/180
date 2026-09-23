import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../../data/repositories/curriculum_repository.dart';
import '../../../data/repositories/progress_repository.dart';
import '../../../data/models/curriculum_models.dart';
import '../../../features/auth/providers/auth_providers.dart';

final monthsProvider = FutureProvider<List<MonthModel>>((ref) async {
  final repo = ref.read(curriculumRepositoryProvider);
  return repo.getMonths();
});

final userCompletedDaysProvider = FutureProvider<Set<int>>((ref) async {
  final userId = ref.watch(currentProfileProvider).valueOrNull?.id;
  if (userId == null) return {};
  final repo = ref.read(progressRepositoryProvider);
  final progress = await repo.getUserProgress(userId);
  // We need day numbers — fetch them from tasks
  return progress.where((p) => p.completed).map((p) => 0).toSet();
});

class RoadmapScreen extends ConsumerWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthsAsync = ref.watch(monthsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CyberBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              floating: true,
              leading: Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu, color: AppColors.textPrimary),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                ),
              ),
              title: Text(
                '180-DAY ROADMAP',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      letterSpacing: 1,
                    ),
              ),
              centerTitle: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: AppColors.glowGradient,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderGlow),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🛡️ YOUR CYBER JOURNEY',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.cyberCyan,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'From computer basics to cybersecurity career — 6 months, 24 weeks, 180 days.',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(),
                  const SizedBox(height: 20),

                  monthsAsync.when(
                    data: (months) => months.isEmpty
                        ? _buildEmptyState(context)
                        : Column(
                            children: months
                                .asMap()
                                .entries
                                .map((e) => _MonthCard(
                                      month: e.value,
                                      index: e.key,
                                    ))
                                .toList(),
                          ),
                    loading: () => Column(
                      children: List.generate(
                        6,
                        (i) => Container(
                          height: 120,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppColors.bgCard,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    error: (e, _) => Center(
                      child: Column(
                        children: [
                          const Icon(Icons.wifi_off,
                              color: AppColors.textHint, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            'Could not load curriculum.\nCheck your connection.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: () => ref.refresh(monthsProvider),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 48),
          const Icon(Icons.hourglass_empty,
              color: AppColors.textHint, size: 48),
          const SizedBox(height: 16),
          Text(
            'Curriculum not loaded yet.\nContact your admin.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

class _MonthCard extends ConsumerWidget {
  final MonthModel month;
  final int index;

  const _MonthCard({required this.month, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = AppColors.monthColors[index % AppColors.monthColors.length];
    return GestureDetector(
      onTap: () => context.push('/roadmap/month/${month.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.25)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.06),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'M${month.monthNumber}',
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    month.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Days ${month.daysStart}–${month.daysEnd}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    month.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textHint,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textHint),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 80));
  }
}
