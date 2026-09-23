import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/progress_repository.dart';
import '../../../data/repositories/curriculum_repository.dart';
import '../../../data/models/curriculum_models.dart';
import '../../../features/auth/providers/auth_providers.dart';

// Today's day number (based on user's completed days + 1)
final currentDayNumberProvider = FutureProvider<int>((ref) async {
  final userId = ref.watch(currentProfileProvider).valueOrNull?.id;
  if (userId == null) return 1;
  final repo = ref.read(progressRepositoryProvider);
  final progress = await repo.getUserProgress(userId);
  final completedCount = progress.where((p) => p.completed).length;
  return (completedCount + 1).clamp(1, 180);
});

// Streak provider
final streakProvider = FutureProvider<StreakModel>((ref) async {
  final userId = ref.watch(currentProfileProvider).valueOrNull?.id;
  if (userId == null) return StreakModel(userId: '');
  final repo = ref.read(progressRepositoryProvider);
  return repo.getStreak(userId);
});

// Total XP provider
final totalXpProvider = FutureProvider<int>((ref) async {
  final userId = ref.watch(currentProfileProvider).valueOrNull?.id;
  if (userId == null) return 0;
  final repo = ref.read(progressRepositoryProvider);
  return repo.getTotalXp(userId);
});

// User progress summary
final userProgressSummaryProvider =
    FutureProvider<_ProgressSummary>((ref) async {
  final userId = ref.watch(currentProfileProvider).valueOrNull?.id;
  if (userId == null) {
    return const _ProgressSummary(
      completedDays: 0,
      totalStudyMinutes: 0,
    );
  }
  final repo = ref.read(progressRepositoryProvider);
  final progress = await repo.getUserProgress(userId);
  final sessions = await repo.getStudySessions(userId);
  final completedDays = progress.where((p) => p.completed).length;
  final totalMinutes = sessions.fold<int>(
    0,
    (sum, s) => sum + (s['duration_minutes'] as int? ?? 0),
  );
  return _ProgressSummary(
    completedDays: completedDays,
    totalStudyMinutes: totalMinutes,
  );
});

class _ProgressSummary {
  final int completedDays;
  final int totalStudyMinutes;
  const _ProgressSummary({
    required this.completedDays,
    required this.totalStudyMinutes,
  });
}

// Today's task
final todayTaskProvider = FutureProvider<DailyTaskModel?>((ref) async {
  final dayNumber = await ref.watch(currentDayNumberProvider.future);
  try {
    final repo = ref.read(curriculumRepositoryProvider);
    return await repo.getDayTask(dayNumber);
  } catch (_) {
    return null;
  }
});
