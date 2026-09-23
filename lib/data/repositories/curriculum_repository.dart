import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/supabase_service.dart';
import '../models/curriculum_models.dart';

final curriculumRepositoryProvider = Provider<CurriculumRepository>((ref) {
  return CurriculumRepositoryImpl();
});

abstract class CurriculumRepository {
  Future<List<MonthModel>> getMonths();
  Future<List<WeekModel>> getWeeks({int? monthId});
  Future<DailyTaskModel> getDayTask(int dayNumber);
  Future<List<DailyTaskModel>> getDaysByWeek(int weekNumber);
  Future<List<DailyTaskModel>> getDaysByMonth(int monthNumber);
  Future<List<ResourceModel>> getResourcesByDay(String dayTaskId);
  Future<List<ChecklistItemModel>> getChecklistItems(String dayTaskId);
}

class CurriculumRepositoryImpl implements CurriculumRepository {
  @override
  Future<List<MonthModel>> getMonths() async {
    final data = await SupabaseService.months.select().order('month_number');
    return (data as List).map((e) => MonthModel.fromJson(e)).toList();
  }

  @override
  Future<List<WeekModel>> getWeeks({int? monthId}) async {
    var query = SupabaseService.weeks.select();
    if (monthId != null) {
      final monthData = await SupabaseService.months
          .select('id')
          .eq('month_number', monthId)
          .maybeSingle();
      if (monthData != null) {
        query = SupabaseService.weeks
            .select()
            .eq('month_id', monthData['id'] as String);
      }
    }
    final data = await query.order('week_number');
    return (data as List).map((e) => WeekModel.fromJson(e)).toList();
  }

  @override
  Future<DailyTaskModel> getDayTask(int dayNumber) async {
    final data = await SupabaseService.dailyTasks
        .select()
        .eq('day_number', dayNumber)
        .single();

    final taskId = data['id'] as String;
    final checklist = await getChecklistItems(taskId);
    final resources = await getResourcesByDay(taskId);

    return DailyTaskModel.fromJson(data,
        checklist: checklist, resources: resources);
  }

  @override
  Future<List<DailyTaskModel>> getDaysByWeek(int weekNumber) async {
    final data = await SupabaseService.dailyTasks
        .select()
        .eq('week_number', weekNumber)
        .order('day_number');
    return (data as List).map((e) => DailyTaskModel.fromJson(e)).toList();
  }

  @override
  Future<List<DailyTaskModel>> getDaysByMonth(int monthNumber) async {
    final data = await SupabaseService.dailyTasks
        .select()
        .eq('month_number', monthNumber)
        .order('day_number');
    return (data as List).map((e) => DailyTaskModel.fromJson(e)).toList();
  }

  @override
  Future<List<ResourceModel>> getResourcesByDay(String dayTaskId) async {
    final data = await SupabaseService.client
        .from('daily_resources')
        .select('resource_id, resources(*)')
        .eq('day_task_id', dayTaskId);

    return (data as List).map((e) {
      final resourceData = e['resources'] as Map<String, dynamic>;
      return ResourceModel.fromJson(resourceData);
    }).toList();
  }

  @override
  Future<List<ChecklistItemModel>> getChecklistItems(String dayTaskId) async {
    final data = await SupabaseService.checklistItems
        .select()
        .eq('day_task_id', dayTaskId)
        .order('sort_order');
    return (data as List).map((e) => ChecklistItemModel.fromJson(e)).toList();
  }
}
