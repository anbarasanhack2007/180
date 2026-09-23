import 'package:equatable/equatable.dart';

class TestEntity extends Equatable {
  final String id;
  final String title;
  final String testType;
  final int? weekNumber;
  final int? monthNumber;
  final int? dayNumber;
  final String description;
  final List<Question> questions;

  const TestEntity({
    required this.id,
    required this.title,
    required this.testType,
    this.weekNumber,
    this.monthNumber,
    this.dayNumber,
    required this.description,
    this.questions = const [],
  });

  @override
  List<Object?> get props => [id, title];
}

class Question extends Equatable {
  final String id;
  final String testId;
  final String question;
  final String questionType;
  final List<String> options;
  final dynamic correctAnswer;
  final String? explanation;
  final String difficulty;
  final int points;
  final int sortOrder;

  const Question({
    required this.id,
    required this.testId,
    required this.question,
    required this.questionType,
    required this.options,
    required this.correctAnswer,
    this.explanation,
    required this.difficulty,
    required this.points,
    required this.sortOrder,
  });

  @override
  List<Object?> get props => [id, question];
}

class TestAttempt extends Equatable {
  final String id;
  final String userId;
  final String testId;
  final int score;
  final int totalPoints;
  final DateTime startedAt;
  final DateTime? completedAt;
  final List<TestAnswer> answers;

  const TestAttempt({
    required this.id,
    required this.userId,
    required this.testId,
    required this.score,
    required this.totalPoints,
    required this.startedAt,
    this.completedAt,
    this.answers = const [],
  });

  double get percentage => totalPoints > 0 ? (score / totalPoints * 100) : 0;

  @override
  List<Object?> get props => [id, userId, testId];
}

class TestAnswer extends Equatable {
  final String attemptId;
  final String questionId;
  final dynamic answer;
  final bool isCorrect;
  final int pointsAwarded;

  const TestAnswer({
    required this.attemptId,
    required this.questionId,
    required this.answer,
    required this.isCorrect,
    required this.pointsAwarded,
  });

  @override
  List<Object?> get props => [attemptId, questionId];
}

class InterviewQuestion extends Equatable {
  final String id;
  final String category;
  final String question;
  final String answer;
  final String? explanation;
  final String difficulty;

  const InterviewQuestion({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
    this.explanation,
    required this.difficulty,
  });

  @override
  List<Object?> get props => [id, question];
}

class UserInterviewProgress extends Equatable {
  final String userId;
  final String questionId;
  final String status; // 'known', 'needs_revision', 'skipped'
  final DateTime updatedAt;

  const UserInterviewProgress({
    required this.userId,
    required this.questionId,
    required this.status,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [userId, questionId];
}

class UserSettings extends Equatable {
  final String userId;
  final String theme;
  final bool notificationsEnabled;
  final String? dailyReminderTime;
  final bool soundEnabled;
  final String language;

  const UserSettings({
    required this.userId,
    this.theme = 'dark',
    this.notificationsEnabled = true,
    this.dailyReminderTime,
    this.soundEnabled = true,
    this.language = 'en',
  });

  UserSettings copyWith({
    String? userId,
    String? theme,
    bool? notificationsEnabled,
    String? dailyReminderTime,
    bool? soundEnabled,
    String? language,
  }) {
    return UserSettings(
      userId: userId ?? this.userId,
      theme: theme ?? this.theme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dailyReminderTime: dailyReminderTime ?? this.dailyReminderTime,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [userId, theme, notificationsEnabled];
}
