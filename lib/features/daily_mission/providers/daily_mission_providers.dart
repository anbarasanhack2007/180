import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/curriculum_repository.dart';
import '../../../data/repositories/progress_repository.dart';
import '../../../data/models/curriculum_models.dart';

// Fetch a specific day task with full details
final dailyTaskDetailProvider =
    FutureProvider.family<DailyTaskModel, int>((ref, dayNumber) async {
  final repo = ref.read(curriculumRepositoryProvider);
  return repo.getDayTask(dayNumber);
});

// Day progress for a specific task
final dayProgressProvider =
    FutureProvider.family<DailyProgressModel?, (String, String)>(
  (ref, args) async {
    final (userId, dayTaskId) = args;
    final repo = ref.read(progressRepositoryProvider);
    return repo.getDayProgress(userId, dayTaskId);
  },
);

// Checklist progress
final checklistProgressProvider =
    FutureProvider.family<Map<String, bool>, (String, String, List<String>)>(
  (ref, args) async {
    final (userId, dayTaskId, itemIds) = args;
    if (itemIds.isEmpty) return {};
    final repo = ref.read(progressRepositoryProvider);
    return repo.getChecklistProgress(userId, dayTaskId, itemIds);
  },
);
