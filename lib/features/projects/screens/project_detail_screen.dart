import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../../services/supabase_service.dart';

final projectDetailProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, id) async {
  final data = await SupabaseService.projects
      .select('*, project_tasks(*)')
      .eq('id', id)
      .maybeSingle();
  return data;
});

class ProjectDetailScreen extends ConsumerWidget {
  final String projectId;
  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(projectDetailProvider(projectId));
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CyberBackground(
        child: async.when(
          data: (project) {
            if (project == null) {
              return const Center(
                  child: Text('Project not found',
                      style: TextStyle(color: AppColors.textSecondary)));
            }
            final number = project['project_number'] as int? ?? 1;
            final colors = [
              AppColors.cyberCyan,
              AppColors.cyberBlue,
              AppColors.cyberPurple,
              AppColors.cyberGreen,
              AppColors.cyberOrange,
              AppColors.cyberPink,
            ];
            final color = colors[(number - 1).clamp(0, colors.length - 1)];
            final tasks = project['project_tasks'] as List<dynamic>? ?? [];

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
                    'PROJECT $number',
                    style: TextStyle(color: color, fontWeight: FontWeight.w800),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Text(
                        project['title'] as String? ?? '',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        project['description'] as String? ?? '',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 16),

                      // Objective
                      _InfoCard(
                        title: 'OBJECTIVE',
                        content: project['objective'] as String? ?? '',
                        icon: Icons.flag_outlined,
                        color: color,
                      ),
                      const SizedBox(height: 12),

                      // Architecture
                      if ((project['architecture'] as String?)?.isNotEmpty ??
                          false)
                        _InfoCard(
                          title: 'ARCHITECTURE',
                          content: project['architecture'] as String,
                          icon: Icons.architecture,
                          color: AppColors.cyberBlue,
                        ),
                      const SizedBox(height: 12),

                      // Tech stack
                      if (project['tech_stack'] != null) ...[
                        Text('TECH STACK',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: AppColors.textHint,
                                    letterSpacing: 1)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: (project['tech_stack'] as List<dynamic>)
                              .map((t) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          color: color.withValues(alpha: 0.2)),
                                    ),
                                    child: Text(t.toString(),
                                        style: TextStyle(
                                            color: color, fontSize: 12)),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // GitHub
                      if ((project['github_url'] as String?)?.isNotEmpty ??
                          false)
                        ElevatedButton.icon(
                          onPressed: () async {
                            final url = project['github_url'] as String;
                            final uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                          icon: const Icon(Icons.code),
                          label: const Text('VIEW ON GITHUB'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            foregroundColor: AppColors.bgPrimary,
                          ),
                        ),

                      const SizedBox(height: 16),

                      // Tasks / Milestones
                      if (tasks.isNotEmpty) ...[
                        Text('MILESTONES',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: AppColors.textHint,
                                    letterSpacing: 1)),
                        const SizedBox(height: 8),
                        ...tasks.asMap().entries.map((e) {
                          final task = e.value as Map<String, dynamic>;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.bgCard,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.borderColor),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${e.key + 1}',
                                      style: TextStyle(
                                          color: color,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task['title'] as String? ?? '',
                                        style: const TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      if ((task['description'] as String?)
                                              ?.isNotEmpty ??
                                          false)
                                        Text(
                                          task['description'] as String,
                                          style: const TextStyle(
                                              color: AppColors.textHint,
                                              fontSize: 11),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
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
              child: Text('Error: ${e.toString()}',
                  style: const TextStyle(color: AppColors.cyberRed))),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color color;

  const _InfoCard({
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 15),
              const SizedBox(width: 6),
              Text(title,
                  style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 8),
          Text(content,
              style:
                  const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
        ],
      ),
    );
  }
}
