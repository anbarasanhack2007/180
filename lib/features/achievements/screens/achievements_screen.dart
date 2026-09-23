import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../../services/supabase_service.dart';

final achievementsListProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final userId = SupabaseService.currentUserId;
    final allAch = await SupabaseService.achievements
        .select()
        .order('xp_reward', ascending: true);
    List<dynamic> userAch = [];
    if (userId != null) {
      userAch =
          await SupabaseService.userAchievements.select().eq('user_id', userId);
    }
    final unlockedIds = {
      for (var item in userAch) item['achievement_id']: item['unlocked_at']
    };

    if (allAch.isNotEmpty) {
      return allAch.map((ach) {
        final isUnlocked = unlockedIds.containsKey(ach['id']);
        return {
          ...ach,
          'unlocked': isUnlocked,
          'unlocked_at': unlockedIds[ach['id']],
        };
      }).toList();
    }
  } catch (_) {}

  // Fallback rich cyber badges
  return [
    {
      'id': 'ach-1',
      'title': 'First Blood',
      'description': 'Completed your very first CyberSprint daily mission.',
      'badge_icon': 'bolt',
      'xp_reward': 50,
      'unlocked': true,
      'unlocked_at':
          DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
    },
    {
      'id': 'ach-2',
      'title': 'Terminal Initiate',
      'description':
          'Mastered basic Linux shell commands and file permissions.',
      'badge_icon': 'terminal',
      'xp_reward': 100,
      'unlocked': true,
      'unlocked_at':
          DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
    },
    {
      'id': 'ach-3',
      'title': 'Packet Sniffer',
      'description':
          'Analyzed live TCP/IP streams and DNS handshakes in Wireshark.',
      'badge_icon': 'wifi',
      'xp_reward': 150,
      'unlocked': false,
    },
    {
      'id': 'ach-4',
      'title': '7-Day Unbroken Streak',
      'description':
          'Maintained consistent cybersecurity practice for 7 days in a row.',
      'badge_icon': 'local_fire_department',
      'xp_reward': 250,
      'unlocked': false,
    },
    {
      'id': 'ach-5',
      'title': 'Payload Crafter',
      'description':
          'Successfully completed all Web Security Academy SQLi & XSS labs.',
      'badge_icon': 'bug_report',
      'xp_reward': 300,
      'unlocked': false,
    },
    {
      'id': 'ach-6',
      'title': 'SOC Tier-1 Certified',
      'description':
          'Analyzed real SIEM logs and detected a simulated brute-force campaign.',
      'badge_icon': 'shield',
      'xp_reward': 500,
      'unlocked': false,
    },
    {
      'id': 'ach-7',
      'title': 'CyberSprint Champion',
      'description': 'Completed all 180 days of the cybersecurity curriculum.',
      'badge_icon': 'military_tech',
      'xp_reward': 1000,
      'unlocked': false,
    },
  ];
});

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  IconData _getIcon(String? icon) {
    switch (icon) {
      case 'bolt':
        return Icons.bolt;
      case 'terminal':
        return Icons.terminal;
      case 'wifi':
        return Icons.wifi;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'bug_report':
        return Icons.bug_report;
      case 'shield':
        return Icons.shield;
      case 'military_tech':
        return Icons.military_tech;
      default:
        return Icons.emoji_events;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(achievementsListProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CyberBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: AppColors.textPrimary),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'HALL OF VALOR',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppColors.cyberCyan,
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            'Badges & Achievements',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Achievements Grid
              Expanded(
                child: achievementsAsync.when(
                  loading: () => const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.cyberCyan),
                  ),
                  error: (err, _) => Center(
                    child: Text('Error loading badges: $err',
                        style: const TextStyle(color: AppColors.neonRed)),
                  ),
                  data: (badges) {
                    final unlockedCount =
                        badges.where((b) => b['unlocked'] == true).length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Progress bar card
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.cyberCyan.withValues(alpha: 0.1),
                                  AppColors.bgCard,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: AppColors.cyberCyan
                                      .withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                const Text('🎖️',
                                    style: TextStyle(fontSize: 28)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$unlockedCount of ${badges.length} Badges Unlocked',
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: badges.isEmpty
                                              ? 0
                                              : unlockedCount / badges.length,
                                          backgroundColor: AppColors.bgSurface,
                                          valueColor:
                                              const AlwaysStoppedAnimation(
                                                  AppColors.cyberCyan),
                                          minHeight: 6,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Badges Grid
                        Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.95,
                            ),
                            itemCount: badges.length,
                            itemBuilder: (context, index) {
                              final b = badges[index];
                              final isUnlocked = b['unlocked'] == true;
                              final icon = _getIcon(b['badge_icon']);

                              return Container(
                                decoration: BoxDecoration(
                                  color: AppColors.bgCard,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isUnlocked
                                        ? AppColors.cyberCyan
                                            .withValues(alpha: 0.5)
                                        : AppColors.borderColor
                                            .withValues(alpha: 0.5),
                                  ),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isUnlocked
                                            ? AppColors.cyberCyan
                                                .withValues(alpha: 0.15)
                                            : AppColors.bgSurface,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isUnlocked
                                              ? AppColors.cyberCyan
                                              : AppColors.borderColor,
                                        ),
                                      ),
                                      child: Icon(
                                        icon,
                                        color: isUnlocked
                                            ? AppColors.cyberCyan
                                            : AppColors.textMuted,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      b['title'] ?? '',
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: isUnlocked
                                            ? AppColors.textPrimary
                                            : AppColors.textMuted,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      b['description'] ?? '',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppColors.textMuted,
                                        fontSize: 10,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isUnlocked
                                            ? AppColors.matrixGreen
                                                .withValues(alpha: 0.15)
                                            : AppColors.bgSurface,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '+${b['xp_reward']} XP',
                                        style: TextStyle(
                                          color: isUnlocked
                                              ? AppColors.matrixGreen
                                              : AppColors.textMuted,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ).animate().fadeIn(
                                  duration: 200.ms, delay: (index * 30).ms);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
