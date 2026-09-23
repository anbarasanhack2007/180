import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String? college;
  final String? degree;
  final int? studyYear;
  final int dailyGoalMinutes;
  final String? avatarUrl;
  final String? githubUrl;
  final String? linkedinUrl;
  final String? portfolioUrl;
  final String role;
  final String? cybersecurityLevel;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    this.college,
    this.degree,
    this.studyYear,
    this.dailyGoalMinutes = 120,
    this.avatarUrl,
    this.githubUrl,
    this.linkedinUrl,
    this.portfolioUrl,
    this.role = 'user',
    this.cybersecurityLevel,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isAdmin => role == 'admin';

  UserProfile copyWith({
    String? id,
    String? fullName,
    String? email,
    String? college,
    String? degree,
    int? studyYear,
    int? dailyGoalMinutes,
    String? avatarUrl,
    String? githubUrl,
    String? linkedinUrl,
    String? portfolioUrl,
    String? role,
    String? cybersecurityLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      college: college ?? this.college,
      degree: degree ?? this.degree,
      studyYear: studyYear ?? this.studyYear,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      portfolioUrl: portfolioUrl ?? this.portfolioUrl,
      role: role ?? this.role,
      cybersecurityLevel: cybersecurityLevel ?? this.cybersecurityLevel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, fullName, email, role];
}
