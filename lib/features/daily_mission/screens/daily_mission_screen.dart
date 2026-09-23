import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../../core/widgets/cyber_button.dart';
import '../../../data/repositories/curriculum_repository.dart';
import '../../../data/repositories/progress_repository.dart';
import '../../../data/models/curriculum_models.dart';
import '../../../domain/entities/daily_task.dart';
import '../../../features/auth/providers/auth_providers.dart';
import '../providers/daily_mission_providers.dart';
import '../widgets/study_timer_widget.dart';

class DailyMissionScreen extends ConsumerStatefulWidget {
  final int dayNumber;
  const DailyMissionScreen({super.key, required this.dayNumber});

  @override
  ConsumerState<DailyMissionScreen> createState() =>
      _DailyMissionScreenState();
}

class _DailyMissionScreenState extends ConsumerState<DailyMissionScreen> {
  bool _showTimer = false;

  @override
  Widget build(BuildContext context) {
    final taskAsync = ref.watch(dailyTaskDetailProvider(widget.dayNumber));
    final userId = ref.watch(currentProfileProvider).valueOrNull?.id;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CyberBackground(
        child: taskAsync.when(
          data: (task) => _buildContent(context, task, userId),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.cyberCyan),
          ),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, color: AppColors.textHint, size: 56),
                  const SizedBox(height: 16),
                  Text(
                    'Could not load Day ${widget.dayNumber}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check your connection or ensure the curriculum is loaded.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () => ref.refresh(
                        dailyTaskDetailProvider(widget.dayNumber)),
                    child: const Text('Retry'),
                  ),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, DailyTaskModel task, String? userId) {
    final monthIndex = task.monthNumber - 1;
    final color = AppColors.monthColors[
        monthIndex.clamp(0, AppColors.monthColors.length - 1)];

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          pinned: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'DAY ${task.dayNumber}',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.timer_outlined, color: AppColors.textPrimary),
              onPressed: () => setState(() => _showTimer = !_showTimer),
              tooltip: 'Study Timer',
            ),
            if (userId != null)
              IconButton(
                icon: const Icon(Icons.note_add_outlined,
                    color: AppColors.textPrimary),
                onPressed: () => context.push('/notes/create',
                    extra: {'dayTaskId': task.id}),
                tooltip: 'Add Note',
              ),
          ],
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Badges
              Row(
                children: [
                  _badge('MONTH ${task.monthNumber}', color),
                  const SizedBox(width: 6),
                  _badge('WEEK ${task.weekNumber}', AppColors.cyberBlue),
                  if (task.isExam) ...[
                    const SizedBox(width: 6),
                    _badge('📝 EXAM', AppColors.cyberRed),
                  ],
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                task.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 6),

              // Topic
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.tag, color: color, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      task.topic,
                      style: TextStyle(
                        color: color,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Info row
              Row(
                children: [
                  const Icon(Icons.timer_outlined,
                      color: AppColors.textHint, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '~${task.estimatedMinutes} min',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textHint,
                        ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.checklist, color: AppColors.textHint, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${task.checklistItems.length} tasks',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textHint,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Study Timer (collapsible)
              if (_showTimer) ...[
                StudyTimerWidget(dayTaskId: task.id),
                const SizedBox(height: 16),
              ],

              // Objective
              _sectionCard(
                context,
                icon: Icons.flag_outlined,
                title: 'OBJECTIVE',
                iconColor: AppColors.cyberCyan,
                child: Text(
                  task.objective,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                ),
              ),
              const SizedBox(height: 12),

              // Description
              if (task.description.isNotEmpty)
                _sectionCard(
                  context,
                  icon: Icons.description_outlined,
                  title: 'DESCRIPTION',
                  iconColor: AppColors.cyberBlue,
                  child: Text(
                    task.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ),
              if (task.description.isNotEmpty) const SizedBox(height: 12),

              // Resources
              if (task.resources.isNotEmpty) ...[
                _sectionCard(
                  context,
                  icon: Icons.link,
                  title: 'RESOURCES',
                  iconColor: AppColors.cyberPurple,
                  child: Column(
                    children: task.resources
                        .map((r) => _ResourceTile(resource: r.resource))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Checklist
              if (task.checklistItems.isNotEmpty && userId != null) ...[
                _ChecklistSection(
                  task: task,
                  userId: userId,
                ),
                const SizedBox(height: 12),
              ],

              // Safety disclaimer
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cyberOrange.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.cyberOrange.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.security, color: AppColors.cyberOrange, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        AppConstants.educationDisclaimer,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.cyberOrange,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Mark complete button
              if (userId != null)
                _CompletionButton(task: task, userId: userId),
              const SizedBox(height: 32),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _sectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color iconColor,
    required Widget child,
  }) {
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
              Icon(icon, color: iconColor, size: 16),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: iconColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _ResourceTile extends StatelessWidget {
  final Resource resource;
  const _ResourceTile({required this.resource});

  @override
  Widget build(BuildContext context) {
    Color platformColor;
    IconData platformIcon;
    switch (resource.platform) {
      case AppConstants.platformYouTube:
        platformColor = const Color(0xFFFF0000);
        platformIcon = Icons.play_circle_outline;
        break;
      case AppConstants.platformTryHackMe:
        platformColor = AppColors.cyberGreen;
        platformIcon = Icons.science_outlined;
        break;
      case AppConstants.platformPortSwigger:
        platformColor = AppColors.cyberOrange;
        platformIcon = Icons.bug_report_outlined;
        break;
      default:
        platformColor = AppColors.cyberBlue;
        platformIcon = Icons.link;
    }

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: platformColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(platformIcon, color: platformColor, size: 18),
      ),
      title: Text(
        resource.title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        resource.platform,
        style: const TextStyle(color: AppColors.textHint, fontSize: 11),
      ),
      trailing: const Icon(Icons.open_in_new, color: AppColors.textHint, size: 16),
      onTap: () async {
        final url = resource.effectiveUrl;
        if (url.isNotEmpty) {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      },
    );
  }
}

class _ChecklistSection extends ConsumerWidget {
  final DailyTaskModel task;
  final String userId;

  const _ChecklistSection({required this.task, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemIds = task.checklistItems.map((i) => i.id).toList();
    final progressAsync =
        ref.watch(checklistProgressProvider((userId, task.id, itemIds)));

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
              const Icon(Icons.checklist, color: AppColors.cyberCyan, size: 16),
              const SizedBox(width: 6),
              const Text(
                'CHECKLIST',
                style: TextStyle(
                  color: AppColors.cyberCyan,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              progressAsync.when(
                data: (progress) {
                  final done = progress.values.where((v) => v).length;
                  return Text(
                    '$done / ${task.checklistItems.length}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...task.checklistItems.map((item) {
            return progressAsync.when(
              data: (progress) {
                final isChecked = progress[item.id] ?? false;
                return CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    item.title,
                    style: TextStyle(
                      color: isChecked
                          ? AppColors.textHint
                          : AppColors.textPrimary,
                      fontSize: 13,
                      decoration:
                          isChecked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  value: isChecked,
                  onChanged: (val) async {
                    if (val == null) return;
                    await ref
                        .read(progressRepositoryProvider)
                        .toggleChecklistItem(userId, item.id, val);
                    ref.invalidate(checklistProgressProvider);
                  },
                );
              },
              loading: () => const ListTile(
                dense: true,
                title: LinearProgressIndicator(),
              ),
              error: (_, __) => ListTile(
                dense: true,
                title: Text(item.title,
                    style:
                        const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CompletionButton extends ConsumerWidget {
  final DailyTaskModel task;
  final String userId;

  const _CompletionButton({required this.task, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(dayProgressProvider((userId, task.id)));

    return progressAsync.when(
      data: (progress) {
        final isCompleted = progress?.completed ?? false;
        if (isCompleted) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cyberGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.cyberGreen.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle,
                        color: AppColors.cyberGreen, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Day ${task.dayNumber} Complete! +${AppConstants.xpDailyTask} XP',
                      style: const TextStyle(
                        color: AppColors.cyberGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () async {
                  await ref
                      .read(progressRepositoryProvider)
                      .markDayIncomplete(userId, task.id);
                  ref.invalidate(dayProgressProvider);
                },
                icon: const Icon(Icons.undo),
                label: const Text('Mark Incomplete'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.borderColor),
                ),
              ),
            ],
          );
        }

        return CyberButton(
          label: 'MARK DAY COMPLETE ✓',
          icon: Icons.check_circle_outline,
          onPressed: () async {
            await ref
                .read(progressRepositoryProvider)
                .markDayComplete(userId, task.id);
            ref.invalidate(dayProgressProvider);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.xpGold),
                      const SizedBox(width: 8),
                      Text(
                          'Day ${task.dayNumber} complete! +${AppConstants.xpDailyTask} XP earned 🎉'),
                    ],
                  ),
                  backgroundColor: AppColors.bgCard,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
        );
      },
      loading: () => const CyberButton(label: 'Loading...', onPressed: null),
      error: (_, __) =>
          const CyberButton(label: 'MARK COMPLETE', onPressed: null),
    );
  }
}
