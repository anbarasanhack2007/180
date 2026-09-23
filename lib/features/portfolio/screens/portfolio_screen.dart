import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../auth/providers/auth_providers.dart';
import '../../dashboard/providers/dashboard_providers.dart';

class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider).valueOrNull;
    final progress = ref.watch(userProgressSummaryProvider).valueOrNull;
    final streak = ref.watch(streakProvider).valueOrNull;
    final totalXp = ref.watch(totalXpProvider).valueOrNull ?? 350;

    final fullName = profile?.fullName ?? 'Cyber Operator';
    final targetRole = profile?.cybersecurityLevel ?? 'SOC Analyst & Incident Responder';
    final xp = totalXp;
    final completedDays = progress?.completedDays ?? 12;
    final streakDays = streak?.currentStreak ?? 5;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CyberBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Action Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'OPERATOR DOSSIER',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.cyberCyan,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Cyber Portfolio',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined, color: AppColors.textSecondary),
                      onPressed: () => context.push(AppRoutes.settings),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Hero Identity Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.cyberCyan.withValues(alpha: 0.12),
                        AppColors.bgCard,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cyberCyan.withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: AppColors.cyberCyan.withValues(alpha: 0.2),
                            child: const Icon(Icons.shield_outlined, size: 40, color: AppColors.cyberCyan),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        fullName,
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.matrixGreen.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: AppColors.matrixGreen),
                                      ),
                                      child: const Text(
                                        'ACTIVE',
                                        style: TextStyle(
                                          color: AppColors.matrixGreen,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  targetRole,
                                  style: const TextStyle(
                                    color: AppColors.cyberCyan,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'B.Tech 2nd Year | 180-Day Sprint Cadet',
                                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.borderColor),
                      const SizedBox(height: 8),

                      // Quick Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatBadge(context, '$completedDays/180', 'Days Sprint'),
                          _buildStatBadge(context, '$streakDays Days', 'Fire Streak', isFire: true),
                          _buildStatBadge(context, '$xp XP', 'Reputation'),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms),

                const SizedBox(height: 20),

                // Career Tools Grid
                Text(
                  'CAREER WEAPONRY',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textMuted,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _buildToolCard(
                        context,
                        title: 'Resume Builder',
                        subtitle: 'Cyber CV & PDF Export',
                        icon: Icons.description_outlined,
                        color: AppColors.cyberCyan,
                        onTap: () => context.push(AppRoutes.resume),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildToolCard(
                        context,
                        title: 'Interview Flash',
                        subtitle: '150+ Technical Q&As',
                        icon: Icons.quiz_outlined,
                        color: AppColors.neonPurple,
                        onTap: () => context.push(AppRoutes.interview),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _buildToolCard(
                        context,
                        title: 'Analytics Radar',
                        subtitle: 'Study Hours & Velocity',
                        icon: Icons.insights_outlined,
                        color: AppColors.matrixGreen,
                        onTap: () => context.push(AppRoutes.analytics),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildToolCard(
                        context,
                        title: 'Achievements',
                        subtitle: 'Badges & Milestones',
                        icon: Icons.military_tech_outlined,
                        color: AppColors.neonYellow,
                        onTap: () => context.push(AppRoutes.achievements),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Featured Capstone Projects
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CAPSTONE REPOSITORY',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textMuted,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.projects),
                      child: const Text('View All (6)', style: TextStyle(color: AppColors.cyberCyan, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                _buildProjectHighlight(
                  title: 'Network Packet Sniffer & Protocol Analyzer',
                  tech: 'Python, Scapy, Raw Sockets, Wireshark',
                  status: 'Completed',
                  githubUrl: 'https://github.com',
                ),
                const SizedBox(height: 10),
                _buildProjectHighlight(
                  title: 'Automated Port Scanner & Service Fingerprinter',
                  tech: 'Python, Multi-threading, Nmap Scripting',
                  status: 'In Progress',
                  githubUrl: 'https://github.com',
                ),
                const SizedBox(height: 10),
                _buildProjectHighlight(
                  title: 'SOC Log Analysis & SIEM Detection Pipeline',
                  tech: 'Splunk, ELK, Snort, Zeek',
                  status: 'Upcoming',
                  githubUrl: 'https://github.com',
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatBadge(BuildContext context, String value, String label, {bool isFire = false}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: isFire ? AppColors.streakFire : AppColors.cyberCyan,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectHighlight({
    required String title,
    required String tech,
    required String status,
    required String githubUrl,
  }) {
    Color statusColor = AppColors.textMuted;
    if (status == 'Completed') statusColor = AppColors.matrixGreen;
    if (status == 'In Progress') statusColor = AppColors.cyberCyan;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(tech, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: statusColor.withValues(alpha: 0.4)),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
