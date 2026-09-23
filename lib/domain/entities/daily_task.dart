import 'package:equatable/equatable.dart';

class DailyTask extends Equatable {
  final String id;
  final int dayNumber;
  final int monthNumber;
  final int weekNumber;
  final String title;
  final String topic;
  final String objective;
  final String description;
  final int estimatedMinutes;
  final bool isExam;
  final List<ChecklistItem> checklistItems;
  final List<DailyResource> resources;

  const DailyTask({
    required this.id,
    required this.dayNumber,
    required this.monthNumber,
    required this.weekNumber,
    required this.title,
    required this.topic,
    required this.objective,
    required this.description,
    required this.estimatedMinutes,
    this.isExam = false,
    this.checklistItems = const [],
    this.resources = const [],
  });

  @override
  List<Object?> get props => [id, dayNumber];
}

class ChecklistItem extends Equatable {
  final String id;
  final String dayTaskId;
  final String title;
  final String itemType;
  final int sortOrder;

  const ChecklistItem({
    required this.id,
    required this.dayTaskId,
    required this.title,
    required this.itemType,
    required this.sortOrder,
  });

  @override
  List<Object?> get props => [id];
}

class DailyResource extends Equatable {
  final String dayTaskId;
  final String resourceId;
  final Resource resource;

  const DailyResource({
    required this.dayTaskId,
    required this.resourceId,
    required this.resource,
  });

  @override
  List<Object?> get props => [dayTaskId, resourceId];
}

class Resource extends Equatable {
  final String id;
  final String title;
  final String platform;
  final String resourceType;
  final String? url;
  final String? channelName;
  final String? searchQuery;
  final String? description;
  final String difficulty;

  const Resource({
    required this.id,
    required this.title,
    required this.platform,
    required this.resourceType,
    this.url,
    this.channelName,
    this.searchQuery,
    this.description,
    required this.difficulty,
  });

  String get effectiveUrl {
    if (url != null && url!.isNotEmpty) return url!;
    if (channelName != null && searchQuery != null) {
      return 'https://www.youtube.com/results?search_query=${Uri.encodeComponent(searchQuery!)}';
    }
    return '';
  }

  @override
  List<Object?> get props => [id];
}
