import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../../services/supabase_service.dart';

final adminTestsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final data = await SupabaseService.tests
        .select()
        .order('created_at', ascending: true);
    if (data.isNotEmpty) return List<Map<String, dynamic>>.from(data);
  } catch (_) {}

  // Fallback complete test suite
  return [
    {
      'id': 'test-1',
      'title': 'Week 1 Quiz: Cyber Fundamentals & CIA Triad',
      'test_type': 'weekly',
      'duration_minutes': 20,
      'passing_score': 75,
      'question_count': 15,
      'description': 'Validates baseline grasp of defense-in-depth, security models, and threat vectors.',
    },
    {
      'id': 'test-2',
      'title': 'Week 2 Quiz: TCP/IP & Wireshark Deep-Dive',
      'test_type': 'weekly',
      'duration_minutes': 25,
      'passing_score': 80,
      'question_count': 20,
      'description': 'Packet filtering syntax, handshake states, and protocol dissection.',
    },
    {
      'id': 'test-3',
      'title': 'Week 3 Quiz: Linux Administration & Privilege Security',
      'test_type': 'weekly',
      'duration_minutes': 25,
      'passing_score': 80,
      'question_count': 20,
      'description': 'File permissions, sudo configurations, SUID binaries, and process auditing.',
    },
    {
      'id': 'test-4',
      'title': 'Month 1 Milestone Exam: Networking & System Foundations',
      'test_type': 'monthly',
      'duration_minutes': 60,
      'passing_score': 80,
      'question_count': 50,
      'description': 'Comprehensive 50-question proctored evaluation covering weeks 1 through 4.',
    },
    {
      'id': 'test-8',
      'title': 'Month 2 Milestone Exam: Linux & Python Tooling',
      'test_type': 'monthly',
      'duration_minutes': 60,
      'passing_score': 80,
      'question_count': 50,
      'description': 'Socket programming, automation scripts, and Linux system hardening.',
    },
    {
      'id': 'test-12',
      'title': 'Month 3 Milestone Exam: Web Application Penetration Testing',
      'test_type': 'monthly',
      'duration_minutes': 60,
      'passing_score': 80,
      'question_count': 50,
      'description': 'OWASP Top 10 vulnerabilities, Burp Suite exploitation, and remediation strategies.',
    },
    {
      'id': 'test-final',
      'title': 'Final CyberSprint 180 Board Exam & Job-Readiness Assessment',
      'test_type': 'final',
      'duration_minutes': 120,
      'passing_score': 85,
      'question_count': 100,
      'description': 'The ultimate capstone exam verifying junior cybersecurity engineer / SOC analyst readiness.',
    },
  ];
});

class AdminTestsScreen extends ConsumerWidget {
  const AdminTestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testsAsync = ref.watch(adminTestsProvider);

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
                      icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EXAM VAULT CONTROLLER',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.cyberCyan,
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            'Assessments & Tests Bank',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
                      onPressed: () => ref.invalidate(adminTestsProvider),
                    ),
                  ],
                ),
              ),

              // Tests List
              Expanded(
                child: testsAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.cyberCyan),
                  ),
                  error: (err, _) => Center(
                    child: Text('Error: $err', style: const TextStyle(color: AppColors.neonRed)),
                  ),
                  data: (tests) {
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: tests.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final t = tests[index];
                        final type = t['test_type'] ?? 'weekly';

                        Color badgeColor = AppColors.cyberCyan;
                        if (type == 'monthly') badgeColor = AppColors.neonYellow;
                        if (type == 'final') badgeColor = AppColors.neonRed;

                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.bgCard,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.borderColor),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: badgeColor.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
                                    ),
                                    child: Text(
                                      type.toUpperCase(),
                                      style: TextStyle(color: badgeColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${t['question_count']} Questions',
                                    style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${t['duration_minutes']} min',
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                t['title'] ?? 'Assessment',
                                style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                t['description'] ?? '',
                                style: const TextStyle(color: AppColors.textMuted, fontSize: 12, height: 1.3),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Pass Mark: ${t['passing_score']}%',
                                    style: const TextStyle(color: AppColors.cyberCyan, fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Previewing questions for ${t['title']}')),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.bgSurface,
                                      foregroundColor: AppColors.cyberCyan,
                                      elevation: 0,
                                      side: const BorderSide(color: AppColors.borderColor),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    ),
                                    child: const Text('Edit Questions', style: TextStyle(fontSize: 11)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 200.ms, delay: (index * 30).ms);
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
