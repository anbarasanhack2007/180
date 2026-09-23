import 'package:equatable/equatable.dart';

class Month extends Equatable {
  final String id;
  final int monthNumber;
  final String title;
  final String description;
  final List<String> objectives;
  final int daysStart;
  final int daysEnd;

  const Month({
    required this.id,
    required this.monthNumber,
    required this.title,
    required this.description,
    required this.objectives,
    required this.daysStart,
    required this.daysEnd,
  });

  int get totalDays => daysEnd - daysStart + 1;

  @override
  List<Object?> get props => [id, monthNumber];
}

class Week extends Equatable {
  final String id;
  final String monthId;
  final int weekNumber;
  final String title;
  final String objective;

  const Week({
    required this.id,
    required this.monthId,
    required this.weekNumber,
    required this.title,
    required this.objective,
  });

  @override
  List<Object?> get props => [id, weekNumber];
}

class UserProgress extends Equatable {
  final String userId;
  final int completedDays;
  final int totalStudyMinutes;
  final int labsCompleted;
  final int projectsCompleted;
  final int testsCompleted;
  final double averageTestScore;
  final int xp;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActivityDate;

  const UserProgress({
    required this.userId,
    this.completedDays = 0,
    this.totalStudyMinutes = 0,
    this.labsCompleted = 0,
    this.projectsCompleted = 0,
    this.testsCompleted = 0,
    this.averageTestScore = 0.0,
    this.xp = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastActivityDate,
  });

  double get completionPercentage => completedDays / 180.0;
  int get totalStudyHours => totalStudyMinutes ~/ 60;

  int get level {
    final thresholds = [0, 100, 250, 500, 900, 1400, 2100, 3000, 4200, 5700, 7500, 10000];
    for (int i = thresholds.length - 1; i >= 0; i--) {
      if (xp >= thresholds[i]) return i + 1;
    }
    return 1;
  }

  @override
  List<Object?> get props => [userId, completedDays, xp];
}

class DailyProgress extends Equatable {
  final String userId;
  final String dayTaskId;
  final bool completed;
  final DateTime? completedAt;

  const DailyProgress({
    required this.userId,
    required this.dayTaskId,
    this.completed = false,
    this.completedAt,
  });

  @override
  List<Object?> get props => [userId, dayTaskId, completed];
}

class ChecklistProgress extends Equatable {
  final String userId;
  final String checklistItemId;
  final bool completed;
  final DateTime? completedAt;

  const ChecklistProgress({
    required this.userId,
    required this.checklistItemId,
    this.completed = false,
    this.completedAt,
  });

  @override
  List<Object?> get props => [userId, checklistItemId, completed];
}

class Streak extends Equatable {
  final String userId;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActivityDate;

  const Streak({
    required this.userId,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastActivityDate,
  });

  @override
  List<Object?> get props => [userId, currentStreak];
}

class XpTransaction extends Equatable {
  final String id;
  final String userId;
  final int amount;
  final String reason;
  final DateTime createdAt;

  const XpTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.reason,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}
