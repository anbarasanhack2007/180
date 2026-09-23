import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final int projectNumber;
  final String title;
  final String description;
  final String objective;
  final String architecture;
  final List<String> techStack;
  final String? githubUrl;
  final String status;
  final List<ProjectTask> tasks;

  const Project({
    required this.id,
    required this.projectNumber,
    required this.title,
    required this.description,
    required this.objective,
    required this.architecture,
    required this.techStack,
    this.githubUrl,
    required this.status,
    this.tasks = const [],
  });

  @override
  List<Object?> get props => [id, projectNumber];
}

class ProjectTask extends Equatable {
  final String id;
  final String projectId;
  final String title;
  final String description;
  final int sortOrder;

  const ProjectTask({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.sortOrder,
  });

  @override
  List<Object?> get props => [id];
}

class UserProjectProgress extends Equatable {
  final String userId;
  final String projectId;
  final int progress;
  final String status;
  final DateTime updatedAt;

  const UserProjectProgress({
    required this.userId,
    required this.projectId,
    this.progress = 0,
    this.status = 'not_started',
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [userId, projectId];
}

class Skill extends Equatable {
  final String id;
  final String name;
  final String category;
  final String description;
  final int sortOrder;

  const Skill({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.sortOrder,
  });

  @override
  List<Object?> get props => [id, name];
}

class UserSkill extends Equatable {
  final String userId;
  final String skillId;
  final String status;
  final int progress;
  final DateTime updatedAt;

  const UserSkill({
    required this.userId,
    required this.skillId,
    this.status = 'not_started',
    this.progress = 0,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [userId, skillId];
}

class Achievement extends Equatable {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int xpReward;
  final String conditionType;
  final int conditionValue;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.xpReward,
    required this.conditionType,
    required this.conditionValue,
  });

  @override
  List<Object?> get props => [id, name];
}

class UserAchievement extends Equatable {
  final String userId;
  final String achievementId;
  final DateTime unlockedAt;
  final Achievement? achievement;

  const UserAchievement({
    required this.userId,
    required this.achievementId,
    required this.unlockedAt,
    this.achievement,
  });

  @override
  List<Object?> get props => [userId, achievementId];
}

class Note extends Equatable {
  final String id;
  final String userId;
  final String? dayTaskId;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    required this.id,
    required this.userId,
    this.dayTaskId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  Note copyWith({
    String? id,
    String? userId,
    String? dayTaskId,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dayTaskId: dayTaskId ?? this.dayTaskId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, title, content];
}

class Bookmark extends Equatable {
  final String id;
  final String userId;
  final String resourceId;
  final DateTime createdAt;
  final Resource? resource;

  const Bookmark({
    required this.id,
    required this.userId,
    required this.resourceId,
    required this.createdAt,
    this.resource,
  });

  @override
  List<Object?> get props => [id, userId, resourceId];
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

class StudySession extends Equatable {
  final String id;
  final String userId;
  final String? dayTaskId;
  final int durationMinutes;
  final DateTime startedAt;
  final DateTime endedAt;

  const StudySession({
    required this.id,
    required this.userId,
    this.dayTaskId,
    required this.durationMinutes,
    required this.startedAt,
    required this.endedAt,
  });

  @override
  List<Object?> get props => [id];
}
