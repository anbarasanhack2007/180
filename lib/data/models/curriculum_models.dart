import '../../domain/entities/daily_task.dart';
import '../../domain/entities/progress.dart';

class MonthModel extends Month {
  const MonthModel({
    required super.id,
    required super.monthNumber,
    required super.title,
    required super.description,
    required super.objectives,
    required super.daysStart,
    required super.daysEnd,
  });

  factory MonthModel.fromJson(Map<String, dynamic> json) {
    return MonthModel(
      id: json['id'] as String,
      monthNumber: json['month_number'] as int,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      objectives: List<String>.from(json['objectives'] as List? ?? []),
      daysStart: json['days_start'] as int,
      daysEnd: json['days_end'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'month_number': monthNumber,
    'title': title,
    'description': description,
    'objectives': objectives,
    'days_start': daysStart,
    'days_end': daysEnd,
  };
}

class WeekModel extends Week {
  const WeekModel({
    required super.id,
    required super.monthId,
    required super.weekNumber,
    required super.title,
    required super.objective,
  });

  factory WeekModel.fromJson(Map<String, dynamic> json) {
    return WeekModel(
      id: json['id'] as String,
      monthId: json['month_id'] as String,
      weekNumber: json['week_number'] as int,
      title: json['title'] as String,
      objective: json['objective'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'month_id': monthId,
    'week_number': weekNumber,
    'title': title,
    'objective': objective,
  };
}

class ResourceModel extends Resource {
  const ResourceModel({
    required super.id,
    required super.title,
    required super.platform,
    required super.resourceType,
    super.url,
    super.channelName,
    super.searchQuery,
    super.description,
    required super.difficulty,
  });

  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      id: json['id'] as String,
      title: json['title'] as String,
      platform: json['platform'] as String,
      resourceType: json['resource_type'] as String,
      url: json['url'] as String?,
      channelName: json['channel_name'] as String?,
      searchQuery: json['search_query'] as String?,
      description: json['description'] as String?,
      difficulty: json['difficulty'] as String? ?? 'beginner',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'platform': platform,
    'resource_type': resourceType,
    if (url != null) 'url': url,
    if (channelName != null) 'channel_name': channelName,
    if (searchQuery != null) 'search_query': searchQuery,
    if (description != null) 'description': description,
    'difficulty': difficulty,
  };
}

class ChecklistItemModel extends ChecklistItem {
  const ChecklistItemModel({
    required super.id,
    required super.dayTaskId,
    required super.title,
    required super.itemType,
    required super.sortOrder,
  });

  factory ChecklistItemModel.fromJson(Map<String, dynamic> json) {
    return ChecklistItemModel(
      id: json['id'] as String,
      dayTaskId: json['day_task_id'] as String,
      title: json['title'] as String,
      itemType: json['item_type'] as String? ?? 'task',
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }
}

class DailyTaskModel extends DailyTask {
  const DailyTaskModel({
    required super.id,
    required super.dayNumber,
    required super.monthNumber,
    required super.weekNumber,
    required super.title,
    required super.topic,
    required super.objective,
    required super.description,
    required super.estimatedMinutes,
    super.isExam,
    super.checklistItems,
    super.resources,
  });

  factory DailyTaskModel.fromJson(
    Map<String, dynamic> json, {
    List<ChecklistItemModel>? checklist,
    List<ResourceModel>? resources,
  }) {
    return DailyTaskModel(
      id: json['id'] as String,
      dayNumber: json['day_number'] as int,
      monthNumber: json['month_number'] as int,
      weekNumber: json['week_number'] as int,
      title: json['title'] as String,
      topic: json['topic'] as String? ?? '',
      objective: json['objective'] as String? ?? '',
      description: json['description'] as String? ?? '',
      estimatedMinutes: json['estimated_minutes'] as int? ?? 60,
      isExam: json['is_exam'] as bool? ?? false,
      checklistItems: checklist ?? [],
      resources: resources?.map((r) => DailyResource(
        dayTaskId: json['id'] as String,
        resourceId: r.id,
        resource: r,
      )).toList() ?? [],
    );
  }
}

class DailyProgressModel extends DailyProgress {
  const DailyProgressModel({
    required super.userId,
    required super.dayTaskId,
    super.completed,
    super.completedAt,
  });

  factory DailyProgressModel.fromJson(Map<String, dynamic> json) {
    return DailyProgressModel(
      userId: json['user_id'] as String,
      dayTaskId: json['day_task_id'] as String,
      completed: json['completed'] as bool? ?? false,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'day_task_id': dayTaskId,
    'completed': completed,
    if (completedAt != null) 'completed_at': completedAt!.toIso8601String(),
  };
}

class ChecklistProgressModel extends ChecklistProgress {
  const ChecklistProgressModel({
    required super.userId,
    required super.checklistItemId,
    super.completed,
    super.completedAt,
  });

  factory ChecklistProgressModel.fromJson(Map<String, dynamic> json) {
    return ChecklistProgressModel(
      userId: json['user_id'] as String,
      checklistItemId: json['checklist_item_id'] as String,
      completed: json['completed'] as bool? ?? false,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'checklist_item_id': checklistItemId,
    'completed': completed,
    if (completedAt != null) 'completed_at': completedAt!.toIso8601String(),
  };
}

class StreakModel extends Streak {
  const StreakModel({
    required super.userId,
    super.currentStreak,
    super.longestStreak,
    super.lastActivityDate,
  });

  factory StreakModel.fromJson(Map<String, dynamic> json) {
    return StreakModel(
      userId: json['user_id'] as String,
      currentStreak: json['current_streak'] as int? ?? 0,
      longestStreak: json['longest_streak'] as int? ?? 0,
      lastActivityDate: json['last_activity_date'] != null
          ? DateTime.parse(json['last_activity_date'] as String)
          : null,
    );
  }
}
