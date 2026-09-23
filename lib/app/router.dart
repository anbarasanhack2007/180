import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_routes.dart';
import '../features/auth/providers/auth_providers.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/roadmap/screens/roadmap_screen.dart';
import '../features/roadmap/screens/month_detail_screen.dart';
import '../features/roadmap/screens/week_detail_screen.dart';
import '../features/daily_mission/screens/daily_mission_screen.dart';
import '../features/resources/screens/resources_screen.dart';
import '../features/labs/screens/labs_screen.dart';
import '../features/projects/screens/projects_screen.dart';
import '../features/projects/screens/project_detail_screen.dart';
import '../features/tests/screens/tests_screen.dart';
import '../features/tests/screens/test_detail_screen.dart';
import '../features/tests/screens/test_attempt_screen.dart';
import '../features/tests/screens/test_result_screen.dart';
import '../features/skills/screens/skills_screen.dart';
import '../features/notes/screens/notes_screen.dart';
import '../features/notes/screens/note_edit_screen.dart';
import '../features/bookmarks/screens/bookmarks_screen.dart';
import '../features/achievements/screens/achievements_screen.dart';
import '../features/portfolio/screens/portfolio_screen.dart';
import '../features/resume/screens/resume_screen.dart';
import '../features/interview/screens/interview_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/analytics/screens/analytics_screen.dart';
import '../features/search/screens/search_screen.dart';
import '../features/admin/screens/admin_dashboard_screen.dart';
import '../features/admin/screens/admin_users_screen.dart';
import '../features/admin/screens/admin_curriculum_screen.dart';
import '../features/admin/screens/admin_tests_screen.dart';
import '../core/widgets/main_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authStateProvider.stream),
    ),
    redirect: (context, state) {
      final isLoggedIn = ref.read(authRepositoryProvider).isSignedIn;
      final isAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signup ||
          state.matchedLocation == AppRoutes.forgotPassword ||
          state.matchedLocation == AppRoutes.splash;

      if (!isLoggedIn && !isAuthRoute) {
        return AppRoutes.login;
      }

      if (isLoggedIn && isAuthRoute &&
          state.matchedLocation != AppRoutes.splash) {
        final needsOnboarding = ref.read(needsOnboardingProvider);
        if (needsOnboarding) return AppRoutes.onboarding;
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Main Shell with bottom nav
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const DashboardScreen(),
            routes: [
              GoRoute(
                path: 'mission/:dayNumber',
                builder: (context, state) => DailyMissionScreen(
                  dayNumber: int.parse(state.pathParameters['dayNumber']!),
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.roadmap,
            builder: (context, state) => const RoadmapScreen(),
            routes: [
              GoRoute(
                path: 'month/:monthId',
                builder: (context, state) => MonthDetailScreen(
                  monthId: state.pathParameters['monthId']!,
                ),
                routes: [
                  GoRoute(
                    path: 'week/:weekId',
                    builder: (context, state) => WeekDetailScreen(
                      weekId: state.pathParameters['weekId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.labs,
            builder: (context, state) => const LabsScreen(),
          ),
          GoRoute(
            path: AppRoutes.projects,
            builder: (context, state) => const ProjectsScreen(),
            routes: [
              GoRoute(
                path: ':projectId',
                builder: (context, state) => ProjectDetailScreen(
                  projectId: state.pathParameters['projectId']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const PortfolioScreen(),
          ),
        ],
      ),

      // Non-shell routes
      GoRoute(
        path: AppRoutes.resources,
        builder: (context, state) => const ResourcesScreen(),
      ),
      GoRoute(
        path: AppRoutes.tests,
        builder: (context, state) => const TestsScreen(),
        routes: [
          GoRoute(
            path: ':testId',
            builder: (context, state) => TestDetailScreen(
              testId: state.pathParameters['testId']!,
            ),
            routes: [
              GoRoute(
                path: 'attempt',
                builder: (context, state) => TestAttemptScreen(
                  testId: state.pathParameters['testId']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: ':attemptId/result',
            builder: (context, state) => TestResultScreen(
              attemptId: state.pathParameters['attemptId']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.skills,
        builder: (context, state) => const SkillsScreen(),
      ),
      GoRoute(
        path: AppRoutes.notes,
        builder: (context, state) => const NotesScreen(),
        routes: [
          GoRoute(
            path: 'create',
            builder: (context, state) {
              final extra = state.extra as Map<String, String?>?;
              return NoteEditScreen(
                dayTaskId: extra?['dayTaskId'],
              );
            },
          ),
          GoRoute(
            path: ':noteId',
            builder: (context, state) => NoteEditScreen(
              noteId: state.pathParameters['noteId'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.bookmarks,
        builder: (context, state) => const BookmarksScreen(),
      ),
      GoRoute(
        path: AppRoutes.achievements,
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: AppRoutes.portfolio,
        builder: (context, state) => const PortfolioScreen(),
      ),
      GoRoute(
        path: AppRoutes.resume,
        builder: (context, state) => const ResumeScreen(),
      ),
      GoRoute(
        path: AppRoutes.interview,
        builder: (context, state) => const InterviewScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.analytics,
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (context, state) => const SearchScreen(),
      ),

      // Admin routes
      GoRoute(
        path: AppRoutes.adminDashboard,
        builder: (context, state) => const AdminDashboardScreen(),
        routes: [
          GoRoute(
            path: 'users',
            builder: (context, state) => const AdminUsersScreen(),
          ),
          GoRoute(
            path: 'curriculum',
            builder: (context, state) => const AdminCurriculumScreen(),
          ),
          GoRoute(
            path: 'tests',
            builder: (context, state) => const AdminTestsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: const Color(0xFF080E1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFFF1744), size: 64),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

// Helper to refresh GoRouter when auth state changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
