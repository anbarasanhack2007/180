import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../../data/repositories/curriculum_repository.dart';

final adminMonthsProvider = FutureProvider((ref) async {
  final repo = ref.watch(curriculumRepositoryProvider);
  return repo.getMonths();
});

class AdminCurriculumScreen extends ConsumerWidget {
  const AdminCurriculumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthsAsync = ref.watch(adminMonthsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CyberBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: AppColors.textPrimary),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CURRICULUM MATRIX',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppColors.cyberCyan,
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            '180-Day Architecture',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Curriculum Content
              Expanded(
                child: monthsAsync.when(
                  loading: () => const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.cyberCyan),
                  ),
                  error: (err, _) => Center(
                    child: Text('Error: $err',
                        style: const TextStyle(color: AppColors.neonRed)),
                  ),
                  data: (months) {
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: months.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final m = months[index];

                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.bgCard,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.borderColor),
                          ),
                          child: ExpansionTile(
                            leading: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color:
                                    AppColors.cyberCyan.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'M${m.monthNumber}',
                                  style: const TextStyle(
                                      color: AppColors.cyberCyan,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                              ),
                            ),
                            title: Text(
                              m.title,
                              style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            subtitle: Text(
                              'Days ${m.daysStart} - ${m.daysEnd} (30 Missions)',
                              style: const TextStyle(
                                  color: AppColors.textMuted, fontSize: 12),
                            ),
                            childrenPadding:
                                const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            children: [
                              const Divider(color: AppColors.borderColor),
                              const SizedBox(height: 6),
                              Text(
                                m.description,
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                    height: 1.4),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'KEY OBJECTIVES:',
                                style: TextStyle(
                                    color: AppColors.cyberCyan,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0),
                              ),
                              const SizedBox(height: 6),
                              ...m.objectives.map((obj) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('• ',
                                            style: TextStyle(
                                                color: AppColors.cyberCyan)),
                                        Expanded(
                                            child: Text(obj,
                                                style: const TextStyle(
                                                    color:
                                                        AppColors.textSecondary,
                                                    fontSize: 12))),
                                      ],
                                    ),
                                  )),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Month ${m.monthNumber} schedule synced with cloud')),
                                      );
                                    },
                                    icon: const Icon(Icons.sync, size: 14),
                                    label: const Text('Sync Missions',
                                        style: TextStyle(fontSize: 12)),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.cyberCyan,
                                      side: const BorderSide(
                                          color: AppColors.cyberCyan),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 200.ms, delay: (index * 40).ms);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
