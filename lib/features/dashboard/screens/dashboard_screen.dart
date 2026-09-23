import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/dashboard_providers.dart';
import '../../auth/providers/auth_providers.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../../core/widgets/cyber_button.dart';
import '../widgets/stat_grid.dart';
import '../widgets/today_mission_card.dart';
import '../widgets/streak_widget.dart';
import '../widgets/xp_level_widget.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider).valueOrNull;
    final dayAsync = ref.watch(currentDayNumberProvider);
    final summaryAsync = ref.watch(userProgressSummaryProvider);
    final streakAsync = ref.watch(streakProvider);
    final xpAsync = ref.watch(totalXpProvider);
    final todayAsync = ref.watch(todayTaskProvider);

    final greeting = _getGreeting();
    final name = profile?.fullName.split(' ').first ?? 'Defender';

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CyberBackground(
        child: CustomScrollView(
          slivers: [
            // AppBar
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              floating: true,
              leading: Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu, color: AppColors.textPrimary),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                ),
              ),
              title: Row(
                children: [
                  const Icon(Icons.shield_outlined,
                      color: AppColors.cyberCyan, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'CYBERSPRINT 180',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.cyberCyan,
                          letterSpacing: 2,
                        ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: AppColors.textPrimary),
                  onPressed: () => context.push(AppRoutes.search),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined,
                      color: AppColors.textPrimary),
                  onPressed: () {},
                ),
              ],
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),

                  // Greeting
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$greeting,',
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                      ),
                      Text(
                        name,
                        style:
                            Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 20),

                  // Day progress banner
                  dayAsync.when(
                    data: (day) => _buildDayBanner(context, day, summaryAsync.valueOrNull?.completedDays ?? 0),
                    loading: () => _loadingBanner(),
                    error: (_, __) => _buildDayBanner(context, 1, 0),
                  ),
                  const SizedBox(height: 16),

                  // Streak + XP row
                  Row(
                    children: [
                      Expanded(
                        child: streakAsync.when(
                          data: (streak) => StreakWidget(streak: streak),
                          loading: () => const _PlaceholderCard(),
                          error: (_, __) => const _PlaceholderCard(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: xpAsync.when(
                          data: (xp) => XpLevelWidget(xp: xp),
                          loading: () => const _PlaceholderCard(),
                          error: (_, __) => const _PlaceholderCard(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Stats grid
                  summaryAsync.when(
                    data: (s) => StatGrid(
                      completedDays: s.completedDays,
                      studyHours: s.totalStudyMinutes ~/ 60,
                    ),
                    loading: () => const SizedBox(height: 80),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 20),

                  // Today's Mission
                  Text(
                    "TODAY'S MISSION",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.cyberCyan,
                          letterSpacing: 2,
                        ),
                  ),
                  const SizedBox(height: 8),
                  todayAsync.when(
                    data: (task) => task != null
                        ? TodayMissionCard(task: task)
                        : _buildNoTask(context),
                    loading: () => const _LoadingMissionCard(),
                    error: (_, __) => _buildNoTask(context),
                  ),
                  const SizedBox(height: 16),

                  // Action buttons
                  dayAsync.when(
                    data: (day) => Column(
                      children: [
                        CyberButton(
                          label: "START TODAY'S MISSION",
                          icon: Icons.play_arrow,
                          onPressed: () =>
                              context.push('/home/mission/$day'),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: () => context.go(AppRoutes.roadmap),
                          icon: const Icon(Icons.map_outlined),
                          label: const Text('VIEW FULL ROADMAP'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        ),
                      ],
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 24),

                  // Quick links
                  Text(
                    'QUICK ACCESS',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 2,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _buildQuickLinks(context),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayBanner(BuildContext context, int day, int completed) {
    final pct = (completed / 180.0).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D1626), Color(0xFF111C2E)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cyberCyan.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyberCyan.withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt, color: AppColors.cyberCyan, size: 20),
              const SizedBox(width: 6),
              Text(
                'DAY $day / 180',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.cyberCyan,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
              ),
              const Spacer(),
              Text(
                '${(pct * 100).toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: AppColors.progressBg,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.cyberCyan),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$completed days completed • ${180 - completed} remaining',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _loadingBanner() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget _buildNoTask(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: AppColors.cyberGreen, size: 48),
          const SizedBox(height: 12),
          Text(
            'All 180 days complete! 🎉',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLinks(BuildContext context) {
    final links = [
      (Icons.science_outlined, 'Labs', AppRoutes.labs, AppColors.cyberBlue),
      (Icons.quiz_outlined, 'Tests', AppRoutes.tests, AppColors.cyberPurple),
      (Icons.psychology_outlined, 'Skills', AppRoutes.skills, AppColors.cyberGreen),
      (Icons.emoji_events_outlined, 'Awards', AppRoutes.achievements, AppColors.xpGold),
      (Icons.record_voice_over_outlined, 'Interview', AppRoutes.interview, AppColors.cyberPink),
      (Icons.analytics_outlined, 'Analytics', AppRoutes.analytics, AppColors.cyberOrange),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemCount: links.length,
      itemBuilder: (ctx, i) {
        final (icon, label, route, color) = links[i];
        return GestureDetector(
          onTap: () => context.push(route),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 26),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class _LoadingMissionCard extends StatelessWidget {
  const _LoadingMissionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
