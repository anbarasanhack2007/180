import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/supabase_service.dart';
import '../models/curriculum_models.dart';
import '../../core/constants/app_constants.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepositoryImpl();
});

abstract class ProgressRepository {
  Future<List<DailyProgressModel>> getUserProgress(String userId);
  Future<DailyProgressModel?> getDayProgress(String userId, String dayTaskId);
  Future<void> markDayComplete(String userId, String dayTaskId);
  Future<void> markDayIncomplete(String userId, String dayTaskId);
  Future<Map<String, bool>> getChecklistProgress(
      String userId, String dayTaskId, List<String> itemIds);
  Future<void> toggleChecklistItem(
      String userId, String checklistItemId, bool completed);
  Future<StreakModel> getStreak(String userId);
  Future<int> getTotalXp(String userId);
  Future<void> addXp(String userId, int amount, String reason);
  Future<List<Map<String, dynamic>>> getStudySessions(String userId);
  Future<void> saveStudySession({
    required String userId,
    required String? dayTaskId,
    required int durationMinutes,
    required DateTime startedAt,
    required DateTime endedAt,
  });
}

class ProgressRepositoryImpl implements ProgressRepository {
  @override
  Future<List<DailyProgressModel>> getUserProgress(String userId) async {
    final data = await SupabaseService.userDailyProgress
        .select()
        .eq('user_id', userId)
        .eq('completed', true);
    return (data as List)
        .map((e) => DailyProgressModel.fromJson(e))
        .toList();
  }

  @override
  Future<DailyProgressModel?> getDayProgress(
      String userId, String dayTaskId) async {
    final data = await SupabaseService.userDailyProgress
        .select()
        .eq('user_id', userId)
        .eq('day_task_id', dayTaskId)
        .maybeSingle();
    if (data == null) return null;
    return DailyProgressModel.fromJson(data);
  }

  @override
  Future<void> markDayComplete(String userId, String dayTaskId) async {
    await SupabaseService.userDailyProgress.upsert({
      'user_id': userId,
      'day_task_id': dayTaskId,
      'completed': true,
      'completed_at': DateTime.now().toIso8601String(),
    });
    // Award XP
    await addXp(userId, AppConstants.xpDailyTask, 'Daily task completed');
    // Update streak
    await _updateStreak(userId);
  }

  @override
  Future<void> markDayIncomplete(String userId, String dayTaskId) async {
    await SupabaseService.userDailyProgress.upsert({
      'user_id': userId,
      'day_task_id': dayTaskId,
      'completed': false,
      'completed_at': null,
    });
  }

  @override
  Future<Map<String, bool>> getChecklistProgress(
      String userId, String dayTaskId, List<String> itemIds) async {
    if (itemIds.isEmpty) return {};
    final data = await SupabaseService.checklistProgress
        .select()
        .eq('user_id', userId)
        .inFilter('checklist_item_id', itemIds);

    final result = <String, bool>{};
    for (final item in data as List) {
      result[item['checklist_item_id'] as String] =
          item['completed'] as bool? ?? false;
    }
    return result;
  }

  @override
  Future<void> toggleChecklistItem(
      String userId, String checklistItemId, bool completed) async {
    await SupabaseService.checklistProgress.upsert({
      'user_id': userId,
      'checklist_item_id': checklistItemId,
      'completed': completed,
      if (completed)
        'completed_at': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<StreakModel> getStreak(String userId) async {
    final data = await SupabaseService.streaks
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    if (data == null) {
      return StreakModel(userId: userId);
    }
    return StreakModel.fromJson(data);
  }

  @override
  Future<int> getTotalXp(String userId) async {
    final data = await SupabaseService.xpTransactions
        .select('amount')
        .eq('user_id', userId);
    if (data.isEmpty) return 0;
    int total = 0;
    for (final item in data) {
      total += (item['amount'] as int? ?? 0);
    }
    return total;
  }

  @override
  Future<void> addXp(String userId, int amount, String reason) async {
    await SupabaseService.xpTransactions.insert({
      'user_id': userId,
      'amount': amount,
      'reason': reason,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getStudySessions(
      String userId) async {
    final data = await SupabaseService.studySessions
        .select()
        .eq('user_id', userId)
        .order('started_at', ascending: false);
    return List<Map<String, dynamic>>.from(data as List);
  }

  @override
  Future<void> saveStudySession({
    required String userId,
    required String? dayTaskId,
    required int durationMinutes,
    required DateTime startedAt,
    required DateTime endedAt,
  }) async {
    await SupabaseService.studySessions.insert({
      'user_id': userId,
      'day_task_id': dayTaskId,
      'duration_minutes': durationMinutes,
      'started_at': startedAt.toIso8601String(),
      'ended_at': endedAt.toIso8601String(),
    });
  }

  Future<void> _updateStreak(String userId) async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    final streak = await getStreak(userId);
    final lastActivity = streak.lastActivityDate;

    int newCurrentStreak = streak.currentStreak;

    if (lastActivity == null) {
      newCurrentStreak = 1;
    } else {
      final lastDate = DateTime(
          lastActivity.year, lastActivity.month, lastActivity.day);
      final diff = todayDate.difference(lastDate).inDays;
      if (diff == 0) {
        // Already updated today
        return;
      } else if (diff == 1) {
        newCurrentStreak += 1;
      } else {
        newCurrentStreak = 1;
      }
    }

    final newLongest =
        newCurrentStreak > streak.longestStreak
            ? newCurrentStreak
            : streak.longestStreak;

    await SupabaseService.streaks.upsert({
      'user_id': userId,
      'current_streak': newCurrentStreak,
      'longest_streak': newLongest,
      'last_activity_date': todayDate.toIso8601String().substring(0, 10),
    });
  }
}
