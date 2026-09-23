import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/cyber_background.dart';
import '../providers/projects_providers.dart';
import '../../../core/constants/app_routes.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(allProjectsProvider);

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
                'PROJECTS',
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
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: AppColors.glowGradient,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderGlow),
                    ),
                    child: Text(
                      '6 real-world projects to build your cybersecurity portfolio.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  projectsAsync.when(
                    data: (projects) => projects.isEmpty
                        ? _buildEmpty(context)
                        : Column(
                            children: projects
                                .asMap()
                                .entries
                                .map((e) => _ProjectCard(
                                      project: e.value,
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
                          const Icon(Icons.error_outline,
                              color: AppColors.textHint, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            'Could not load projects.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          TextButton(
                            onPressed: () => ref.refresh(allProjectsProvider),
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

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Icon(Icons.folder_outlined,
                color: AppColors.textHint, size: 56),
            const SizedBox(height: 16),
            Text(
              'No projects loaded yet.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Run the seed.sql to populate the curriculum.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends ConsumerWidget {
  final Map<String, dynamic> project;
  final int index;

  const _ProjectCard({required this.project, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectColors = [
      AppColors.cyberCyan,
      AppColors.cyberBlue,
      AppColors.cyberPurple,
      AppColors.cyberGreen,
      AppColors.cyberOrange,
      AppColors.cyberPink,
    ];
    final color = projectColors[index % projectColors.length];
    final progressAsync =
        ref.watch(userProjectProgressProvider(project['id'] as String));

    return GestureDetector(
      onTap: () => context.push('${AppRoutes.projects}/${project['id']}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.25)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.06),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'PROJECT ${project['project_number']}',
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const Spacer(),
                _statusChip(context, project['status'] as String? ?? 'not_started'),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              project['title'] as String? ?? '',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              project['description'] as String? ?? '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            // Tech stack
            if (project['tech_stack'] != null) ...[
              Wrap(
                spacing: 6,
                children: (project['tech_stack'] as List<dynamic>)
                    .take(4)
                    .map((t) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.bgElevated,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            t.toString(),
                            style: const TextStyle(
                              color: AppColors.textHint,
                              fontSize: 10,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 8),
            ],
            // User progress bar
            progressAsync.when(
              data: (progress) {
                final pct = ((progress?['progress'] as int? ?? 0) / 100.0)
                    .clamp(0.0, 1.0);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.textHint),
                        ),
                        Text(
                          '${(pct * 100).toInt()}%',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: color),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: pct,
                      backgroundColor: AppColors.progressBg,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 4,
                    ),
                  ],
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 80));
  }

  Widget _statusChip(BuildContext context, String status) {
    Color color;
    String label;
    switch (status) {
      case 'in_progress':
        color = AppColors.cyberOrange;
        label = 'IN PROGRESS';
        break;
      case 'completed':
        color = AppColors.cyberGreen;
        label = 'COMPLETE';
        break;
      default:
        color = AppColors.textHint;
        label = 'NOT STARTED';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
