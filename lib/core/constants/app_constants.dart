class AppConstants {
  AppConstants._();

  static const String appName = 'CyberSprint 180';
  static const String appTagline = '180 Days. One Skillset. A Cybersecurity Career.';
  static const String appVersion = '1.0.0';

  static const int totalDays = 180;
  static const int totalMonths = 6;
  static const int totalWeeks = 24;
  static const int daysPerMonth = 30;
  static const int daysPerWeek = 7;

  // XP Values
  static const int xpDailyTask = 10;
  static const int xpYouTube = 5;
  static const int xpLab = 20;
  static const int xpProjectMilestone = 50;
  static const int xpWeeklyTest = 30;
  static const int xpMonthlyExam = 100;

  // Level Thresholds
  static const List<int> levelThresholds = [
    0, 100, 250, 500, 900, 1400, 2100, 3000, 4200, 5700, 7500, 10000
  ];
  static const List<String> levelNames = [
    'Rookie', 'Learner', 'Explorer', 'Analyst', 'Defender',
    'Specialist', 'Expert', 'Elite', 'Master', 'Champion',
    'Legend', 'Cyber God'
  ];

  // Timer presets (minutes)
  static const List<int> timerPresets = [25, 45, 60, 90];

  // Study goal defaults (minutes)
  static const int defaultDailyGoalMinutes = 120;

  // Cache keys
  static const String cacheKeyCurriculum = 'curriculum_v1';
  static const String cacheKeyProfile = 'profile_v1';
  static const String cacheKeySettings = 'settings_v1';
  static const String cacheKeyProgress = 'progress_v1';

  // Local notification
  static const String notifChannelId = 'cybersprint_daily';
  static const String notifChannelName = 'Daily Mission';

  // URLs
  static const String educationDisclaimer =
      'Practice only on systems you own or have explicit permission to test.';

  // Resource Platforms
  static const String platformYouTube = 'YouTube';
  static const String platformTryHackMe = 'TryHackMe';
  static const String platformPortSwigger = 'PortSwigger';
  static const String platformGitHub = 'GitHub';
  static const String platformDocument = 'Document';
  static const String platformCourse = 'Course';

  // Resource Types
  static const String typeVideo = 'video';
  static const String typeLab = 'lab';
  static const String typeReadme = 'readme';
  static const String typeCourse = 'course';
  static const String typeDoc = 'documentation';

  // Difficulty
  static const String diffBeginner = 'beginner';
  static const String diffIntermediate = 'intermediate';
  static const String diffAdvanced = 'advanced';

  // User roles
  static const String roleUser = 'user';
  static const String roleAdmin = 'admin';

  // Project statuses
  static const String statusNotStarted = 'not_started';
  static const String statusInProgress = 'in_progress';
  static const String statusCompleted = 'completed';

  // Test types
  static const String testWeekly = 'weekly';
  static const String testMonthly = 'monthly';
  static const String testFinal = 'final';

  // Interview categories
  static const List<String> interviewCategories = [
    'Networking', 'Linux', 'Python', 'Web Security',
    'OWASP', 'Burp Suite', 'SOC', 'SIEM',
    'Incident Response', 'Cybersecurity Fundamentals',
  ];

  // YouTube channel URLs
  static const String ytProfessorMesser = 'https://www.youtube.com/@professormesser';
  static const String ytFreeCodeCamp = 'https://www.youtube.com/@freecodecamp';
  static const String ytCoreySchafer = 'https://www.youtube.com/@coreyms';
  static const String ytPortSwigger = 'https://www.youtube.com/@PortSwiggerOfficial';
  static const String ytJohnHammond = 'https://www.youtube.com/@_JohnHammond';
  static const String ytTCM = 'https://www.youtube.com/@TCMSecurityAcademy';

  // TryHackMe paths
  static const String thmPreSecurity = 'https://tryhackme.com/path/outline/presecurity';
  static const String thmCyberSecurity101 = 'https://tryhackme.com/path/outline/cybersecurity101';
  static const String thmJrPenTester = 'https://tryhackme.com/path/outline/jrpenetrationtester';
  static const String thmSocLevel1 = 'https://tryhackme.com/path/outline/soclevel1';

  // PortSwigger
  static const String portSwiggerWebSecurity = 'https://portswigger.net/web-security';
}
