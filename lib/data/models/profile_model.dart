import '../../domain/entities/user_profile.dart';

class ProfileModel extends UserProfile {
  const ProfileModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.college,
    super.degree,
    super.studyYear,
    super.dailyGoalMinutes,
    super.avatarUrl,
    super.githubUrl,
    super.linkedinUrl,
    super.portfolioUrl,
    super.role,
    super.cybersecurityLevel,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      college: json['college'] as String?,
      degree: json['degree'] as String?,
      studyYear: json['study_year'] as int?,
      dailyGoalMinutes: json['daily_goal_minutes'] as int? ?? 120,
      avatarUrl: json['avatar_url'] as String?,
      githubUrl: json['github_url'] as String?,
      linkedinUrl: json['linkedin_url'] as String?,
      portfolioUrl: json['portfolio_url'] as String?,
      role: json['role'] as String? ?? 'user',
      cybersecurityLevel: json['cybersecurity_level'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      if (college != null) 'college': college,
      if (degree != null) 'degree': degree,
      if (studyYear != null) 'study_year': studyYear,
      'daily_goal_minutes': dailyGoalMinutes,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (githubUrl != null) 'github_url': githubUrl,
      if (linkedinUrl != null) 'linkedin_url': linkedinUrl,
      if (portfolioUrl != null) 'portfolio_url': portfolioUrl,
      if (cybersecurityLevel != null) 'cybersecurity_level': cybersecurityLevel,
    };
  }
}
