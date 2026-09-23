import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._();

  static SupabaseClient get client => Supabase.instance.client;
  static GoTrueClient get auth => Supabase.instance.client.auth;

  static bool get isInitialized {
    try {
      return Supabase.instance.client != null;
    } catch (_) {
      return false;
    }
  }

  static User? get currentUser {
    if (!isInitialized) return null;
    try {
      return auth.currentUser;
    } catch (_) {
      return null;
    }
  }

  static String? get currentUserId => currentUser?.id;
  static bool get isSignedIn => currentUser != null;

  // Auth methods
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await auth.signUp(
      email: email,
      password: password,
    );
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    if (isInitialized) {
      await auth.signOut();
    }
  }

  static Future<void> resetPassword(String email) async {
    if (isInitialized) {
      await auth.resetPasswordForEmail(email);
    }
  }

  static Stream<AuthState> get authStateChanges {
    if (!isInitialized) return const Stream.empty();
    try {
      return auth.onAuthStateChange;
    } catch (_) {
      return const Stream.empty();
    }
  }

  // Profiles
  static SupabaseQueryBuilder get profiles =>
      client.from('profiles');

  // Settings
  static SupabaseQueryBuilder get userSettings =>
      client.from('user_settings');

  // Curriculum
  static SupabaseQueryBuilder get months =>
      client.from('months');

  static SupabaseQueryBuilder get weeks =>
      client.from('weeks');

  static SupabaseQueryBuilder get dailyTasks =>
      client.from('daily_tasks');

  static SupabaseQueryBuilder get checklistItems =>
      client.from('daily_checklist_items');

  static SupabaseQueryBuilder get resources =>
      client.from('resources');

  static SupabaseQueryBuilder get dailyResources =>
      client.from('daily_resources');

  // Progress
  static SupabaseQueryBuilder get userDailyProgress =>
      client.from('user_daily_progress');

  static SupabaseQueryBuilder get checklistProgress =>
      client.from('checklist_progress');

  static SupabaseQueryBuilder get streaks =>
      client.from('streaks');

  static SupabaseQueryBuilder get xpTransactions =>
      client.from('xp_transactions');

  static SupabaseQueryBuilder get studySessions =>
      client.from('study_sessions');

  // Projects
  static SupabaseQueryBuilder get projects =>
      client.from('projects');

  static SupabaseQueryBuilder get projectTasks =>
      client.from('project_tasks');

  static SupabaseQueryBuilder get userProjectProgress =>
      client.from('user_project_progress');

  // Skills
  static SupabaseQueryBuilder get skills =>
      client.from('skills');

  static SupabaseQueryBuilder get userSkills =>
      client.from('user_skills');

  // Achievements
  static SupabaseQueryBuilder get achievements =>
      client.from('achievements');

  static SupabaseQueryBuilder get userAchievements =>
      client.from('user_achievements');

  // Notes & Bookmarks
  static SupabaseQueryBuilder get notes =>
      client.from('notes');

  static SupabaseQueryBuilder get bookmarks =>
      client.from('bookmarks');

  // Tests
  static SupabaseQueryBuilder get tests =>
      client.from('tests');

  static SupabaseQueryBuilder get questions =>
      client.from('questions');

  static SupabaseQueryBuilder get testAttempts =>
      client.from('test_attempts');

  static SupabaseQueryBuilder get testAnswers =>
      client.from('test_answers');

  // Interview
  static SupabaseQueryBuilder get interviewQuestions =>
      client.from('interview_questions');

  static SupabaseQueryBuilder get userInterviewProgress =>
      client.from('user_interview_progress');

  // Career
  static SupabaseQueryBuilder get careerProfiles =>
      client.from('career_profiles');
}
