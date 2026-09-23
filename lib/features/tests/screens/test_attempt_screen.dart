import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../../services/supabase_service.dart';
import '../../../features/auth/providers/auth_providers.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/repositories/progress_repository.dart';

class TestAttemptScreen extends ConsumerStatefulWidget {
  final String testId;
  const TestAttemptScreen({super.key, required this.testId});

  @override
  ConsumerState<TestAttemptScreen> createState() => _TestAttemptScreenState();
}

class _TestAttemptScreenState extends ConsumerState<TestAttemptScreen> {
  List<Map<String, dynamic>> _questions = [];
  int _currentIndex = 0;
  final Map<String, dynamic> _answers = {};
  bool _loading = true;
  bool _submitting = false;
  String? _attemptId;
  DateTime? _startedAt;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await SupabaseService.questions
          .select()
          .eq('test_id', widget.testId)
          .order('sort_order');
      final list = List<Map<String, dynamic>>.from(data as List);
      list.shuffle(Random());
      // Create attempt record
      final userId = ref.read(currentProfileProvider).valueOrNull?.id;
      if (userId != null) {
        _startedAt = DateTime.now();
        final attempt = await SupabaseService.testAttempts
            .insert({
              'user_id': userId,
              'test_id': widget.testId,
              'score': 0,
              'total_points': list.fold<int>(
                  0, (sum, q) => sum + (q['points'] as int? ?? 1)),
              'started_at': _startedAt!.toIso8601String(),
            })
            .select()
            .single();
        _attemptId = attempt['id'] as String;
      }
      setState(() {
        _questions = list;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      int score = 0;
      final userId = ref.read(currentProfileProvider).valueOrNull?.id;

      for (final q in _questions) {
        final qId = q['id'] as String;
        final correct = q['correct_answer'];
        final userAnswer = _answers[qId];
        final isCorrect = _checkAnswer(userAnswer, correct);
        final points = isCorrect ? (q['points'] as int? ?? 1) : 0;
        score += points;

        if (_attemptId != null && userId != null) {
          await SupabaseService.testAnswers.insert({
            'attempt_id': _attemptId,
            'question_id': qId,
            'answer': userAnswer,
            'is_correct': isCorrect,
            'points_awarded': points,
          });
        }
      }

      if (_attemptId != null) {
        await SupabaseService.testAttempts.update({
          'score': score,
          'completed_at': DateTime.now().toIso8601String(),
        }).eq('id', _attemptId!);

        // Award XP
        if (userId != null) {
          await ref.read(progressRepositoryProvider).addXp(
                userId,
                AppConstants.xpWeeklyTest,
                'Test completed',
              );
        }
      }

      if (mounted) {
        context.pushReplacement('/tests/$_attemptId/result');
      }
    } catch (e) {
      setState(() => _submitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error submitting: ${e.toString()}'),
              backgroundColor: AppColors.cyberRed),
        );
      }
    }
  }

  bool _checkAnswer(dynamic userAnswer, dynamic correctAnswer) {
    if (userAnswer == null) return false;
    return userAnswer.toString().trim().toLowerCase() ==
        correctAnswer.toString().trim().toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: Center(
            child: CircularProgressIndicator(color: AppColors.cyberCyan)),
      );
    }
    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.bgPrimary,
        appBar:
            AppBar(backgroundColor: Colors.transparent, leading: BackButton()),
        body: const Center(
            child: Text('No questions found',
                style: TextStyle(color: AppColors.textSecondary))),
      );
    }

    final q = _questions[_currentIndex];
    final isLast = _currentIndex == _questions.length - 1;
    final options = List<String>.from(q['options'] as List? ?? []);
    final qId = q['id'] as String;
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CyberBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close,
                              color: AppColors.textPrimary),
                          onPressed: () => context.pop(),
                        ),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: AppColors.progressBg,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.cyberCyan),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('${_currentIndex + 1}/${_questions.length}',
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Question ${_currentIndex + 1}',
                          style: const TextStyle(
                              color: AppColors.cyberCyan,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1)),
                      const SizedBox(height: 12),
                      Text(q['question'] as String? ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: AppColors.textPrimary, height: 1.5)),
                      const SizedBox(height: 24),
                      // Options
                      ...options.asMap().entries.map((e) {
                        final opt = e.value;
                        final selected = _answers[qId] == opt;
                        return GestureDetector(
                          onTap: () => setState(() => _answers[qId] = opt),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.cyberCyan.withValues(alpha: 0.1)
                                  : AppColors.bgCard,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selected
                                    ? AppColors.cyberCyan
                                    : AppColors.borderColor,
                                width: selected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  selected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: selected
                                      ? AppColors.cyberCyan
                                      : AppColors.textHint,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: Text(opt,
                                        style: TextStyle(
                                          color: selected
                                              ? AppColors.cyberCyan
                                              : AppColors.textPrimary,
                                          fontWeight: selected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                        ))),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // Navigation
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (_currentIndex > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => setState(() => _currentIndex--),
                          child: const Text('BACK'),
                        ),
                      ),
                    if (_currentIndex > 0) const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _submitting
                            ? null
                            : () {
                                if (isLast) {
                                  _submit();
                                } else {
                                  setState(() => _currentIndex++);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cyberCyan,
                          foregroundColor: AppColors.bgPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: _submitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: AppColors.bgPrimary))
                            : Text(isLast ? 'SUBMIT TEST' : 'NEXT →',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
