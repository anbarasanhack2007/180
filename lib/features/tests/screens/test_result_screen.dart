import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../../services/supabase_service.dart';

final testResultProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, attemptId) async {
  final data = await SupabaseService.testAttempts
      .select('*, test_answers(*, questions(question, correct_answer, explanation))')
      .eq('id', attemptId)
      .maybeSingle();
  return data;
});

class TestResultScreen extends ConsumerWidget {
  final String attemptId;
  const TestResultScreen({super.key, required this.attemptId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(testResultProvider(attemptId));
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CyberBackground(
        child: async.when(
          data: (result) {
            if (result == null) {
              return const Center(child: Text('Result not found'));
            }
            final score = result['score'] as int? ?? 0;
            final total = result['total_points'] as int? ?? 1;
            final pct = (score / total * 100).clamp(0, 100);
            Color scoreColor;
            if (pct >= 80) {
              scoreColor = AppColors.cyberGreen;
            } else if (pct >= 60) {
              scoreColor = AppColors.cyberOrange;
            } else {
              scoreColor = AppColors.cyberRed;
            }

            final answers = result['test_answers'] as List<dynamic>? ?? [];

            return SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.textPrimary),
                          onPressed: () => context.go('/tests'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 140, height: 140,
                        child: CircularProgressIndicator(
                          value: pct / 100,
                          strokeWidth: 10,
                          backgroundColor: AppColors.progressBg,
                          valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Column(
                        children: [
                          Text('${pct.toStringAsFixed(0)}%', style: TextStyle(color: scoreColor, fontSize: 32, fontWeight: FontWeight.w900)),
                          Text('$score/$total', style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    pct >= 80 ? '🎉 Excellent!' : pct >= 60 ? '👍 Good job!' : '📚 Keep studying!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: answers.length,
                      itemBuilder: (ctx, i) {
                        final a = answers[i] as Map<String, dynamic>;
                        final isCorrect = a['is_correct'] as bool? ?? false;
                        final q = a['questions'] as Map<String, dynamic>?;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.bgCard,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: isCorrect ? AppColors.cyberGreen.withOpacity(0.3) : AppColors.cyberRed.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: isCorrect ? AppColors.cyberGreen : AppColors.cyberRed, size: 16),
                                const SizedBox(width: 6),
                                Expanded(child: Text(q?['question'] as String? ?? '', style: const TextStyle(color: AppColors.textPrimary, fontSize: 13))),
                              ]),
                              if (!isCorrect && q != null) ...[
                                const SizedBox(height: 6),
                                Text('✓ Correct: ${q['correct_answer']}', style: const TextStyle(color: AppColors.cyberGreen, fontSize: 12)),
                                if (q['explanation'] != null) Text(q['explanation'] as String, style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () => context.go('/tests'),
                      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: AppColors.cyberCyan, foregroundColor: AppColors.bgPrimary),
                      child: const Text('BACK TO TESTS', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.cyberCyan)),
          error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: AppColors.cyberRed))),
        ),
      ),
    );
  }
}
