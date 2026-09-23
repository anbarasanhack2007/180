import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../features/auth/providers/auth_providers.dart';

class MainShell extends ConsumerWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider).valueOrNull;
    final isAdmin = ref.watch(isAdminProvider);
    final location = GoRouterState.of(context).matchedLocation;

    int _currentIndex = 0;
    if (location.startsWith('/roadmap')) _currentIndex = 1;
    else if (location.startsWith('/labs')) _currentIndex = 2;
    else if (location.startsWith('/projects')) _currentIndex = 3;
    else if (location.startsWith('/profile')) _currentIndex = 4;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      drawer: _buildDrawer(context, ref, profile?.fullName ?? 'Defender',
          profile?.email ?? '', isAdmin),
      body: child,
      bottomNavigationBar: _buildBottomNav(context, _currentIndex),
    );
  }

  Widget _buildBottomNav(BuildContext context, int currentIndex) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(top: BorderSide(color: AppColors.borderColor)),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.home);
              break;
            case 1:
              context.go(AppRoutes.roadmap);
              break;
            case 2:
              context.go(AppRoutes.labs);
              break;
            case 3:
              context.go(AppRoutes.projects);
              break;
            case 4:
              context.go(AppRoutes.profile);
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'HOME',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'ROADMAP',
          ),
          NavigationDestination(
            icon: Icon(Icons.science_outlined),
            selectedIcon: Icon(Icons.science),
            label: 'LABS',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder),
            label: 'PROJECTS',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'PROFILE',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, WidgetRef ref, String name,
      String email, bool isAdmin) {
    return Drawer(
      child: Container(
        color: AppColors.bgSurface,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: AppColors.borderColor)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.cyberCyan.withOpacity(0.5),
                            width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cyberCyan.withOpacity(0.15),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: AppColors.cyberCyan,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            email,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Menu items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    _drawerItem(context, Icons.dashboard_outlined, 'Dashboard',
                        AppRoutes.home),
                    _drawerItem(context, Icons.today_outlined, "Today's Mission",
                        '${AppRoutes.home}/mission/1'),
                    _drawerItem(context, Icons.map_outlined, '180-Day Roadmap',
                        AppRoutes.roadmap),
                    _drawerItem(context, Icons.science_outlined, 'Labs',
                        AppRoutes.labs),
                    _drawerItem(context, Icons.folder_outlined, 'Projects',
                        AppRoutes.projects),
                    _drawerItem(context, Icons.quiz_outlined, 'Tests',
                        AppRoutes.tests),
                    _drawerItem(context, Icons.psychology_outlined, 'Skills',
                        AppRoutes.skills),
                    _drawerItem(context, Icons.note_alt_outlined, 'Notes',
                        AppRoutes.notes),
                    _drawerItem(context, Icons.bookmark_outline, 'Bookmarks',
                        AppRoutes.bookmarks),
                    _drawerItem(context, Icons.emoji_events_outlined,
                        'Achievements', AppRoutes.achievements),
                    _drawerItem(context, Icons.work_outline, 'Portfolio',
                        AppRoutes.portfolio),
                    _drawerItem(context, Icons.description_outlined, 'Resume',
                        AppRoutes.resume),
                    _drawerItem(context, Icons.record_voice_over_outlined,
                        'Interview Prep', AppRoutes.interview),
                    _drawerItem(context, Icons.analytics_outlined, 'Analytics',
                        AppRoutes.analytics),
                    _drawerItem(context, Icons.search, 'Search',
                        AppRoutes.search),
                    _drawerItem(context, Icons.settings_outlined, 'Settings',
                        AppRoutes.settings),
                    const Divider(color: AppColors.borderColor),
                    if (isAdmin)
                      _drawerItem(
                        context,
                        Icons.admin_panel_settings_outlined,
                        'Admin Dashboard',
                        AppRoutes.adminDashboard,
                        color: AppColors.cyberPurple,
                      ),
                    ListTile(
                      leading: const Icon(Icons.logout,
                          color: AppColors.cyberRed, size: 20),
                      title: const Text('Logout',
                          style: TextStyle(color: AppColors.cyberRed)),
                      onTap: () async {
                        Navigator.pop(context);
                        await ref.read(authActionsProvider).signOut();
                        if (context.mounted) context.go(AppRoutes.login);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String label,
    String route, {
    Color? color,
  }) {
    final isActive =
        GoRouterState.of(context).matchedLocation.startsWith(route);
    return ListTile(
      leading: Icon(
        icon,
        color: isActive
            ? AppColors.cyberCyan
            : (color ?? AppColors.textSecondary),
        size: 20,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isActive
              ? AppColors.cyberCyan
              : (color ?? AppColors.textPrimary),
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          fontSize: 14,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        context.go(route);
      },
    );
  }
}
