class AppRoutes {
  AppRoutes._();

  // Auth
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String onboarding = '/onboarding';

  // Main Shell
  static const String home = '/home';
  static const String roadmap = '/roadmap';
  static const String labs = '/labs';
  static const String projects = '/projects';
  static const String profile = '/profile';

  // Roadmap
  static const String monthDetail = '/roadmap/month/:monthId';
  static const String weekDetail = '/roadmap/week/:weekId';
  static const String dayMission = '/mission/:dayNumber';

  // Resources
  static const String resources = '/resources';
  static const String youtubeResources = '/resources/youtube';
  static const String thmResources = '/resources/tryhackme';
  static const String portswiggerResources = '/resources/portswigger';

  // Features
  static const String projectDetail = '/projects/:projectId';
  static const String tests = '/tests';
  static const String testDetail = '/tests/:testId';
  static const String testAttempt = '/tests/:testId/attempt';
  static const String testResult = '/tests/:attemptId/result';
  static const String skills = '/skills';
  static const String notes = '/notes';
  static const String noteDetail = '/notes/:noteId';
  static const String noteCreate = '/notes/create';
  static const String bookmarks = '/bookmarks';
  static const String achievements = '/achievements';
  static const String portfolio = '/portfolio';
  static const String resume = '/resume';
  static const String interview = '/interview';
  static const String settings = '/settings';
  static const String analytics = '/analytics';
  static const String search = '/search';

  // Admin
  static const String adminDashboard = '/admin';
  static const String adminUsers = '/admin/users';
  static const String adminCurriculum = '/admin/curriculum';
  static const String adminMonthEdit = '/admin/months/:monthId';
  static const String adminDayEdit = '/admin/days/:dayId';
  static const String adminTests = '/admin/tests';
  static const String adminTestEdit = '/admin/tests/:testId';
  static const String adminProjects = '/admin/projects';
  static const String adminAchievements = '/admin/achievements';
  static const String adminSkills = '/admin/skills';
  static const String adminInterview = '/admin/interview';
  static const String adminResources = '/admin/resources';
}
