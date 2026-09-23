import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/cyber_background.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CyberBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.neonPurple.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: AppColors.neonPurple),
                                ),
                                child: const Text(
                                  'FACULTY ROOT PRIVILEGES',
                                  style: TextStyle(color: AppColors.neonPurple, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'CyberCommand Admin Console',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Live Platform Statistics
                Row(
                  children: [
                    Expanded(
                      child: _buildKpiCard('Cadets Enrolled', '142', '+12 this week', AppColors.cyberCyan, Icons.people_alt_outlined),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildKpiCard('Curriculum Nodes', '180 Days', '6 Full Months', AppColors.matrixGreen, Icons.calendar_month_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildKpiCard('Exams & Quizzes', '30 Tests', '24 Wk + 6 Exams', AppColors.neonYellow, Icons.quiz_outlined),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildKpiCard('Database Sync', 'Healthy', 'RLS Active', AppColors.neonPurple, Icons.shield_outlined),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Text(
                  'COMMAND MODULES',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textMuted,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),

                // Admin Sections
                _buildActionModule(
                  context,
                  title: 'Cadet Roster & Analytics',
                  description: 'Monitor individual student progress, streaks, test scores, and flags.',
                  icon: Icons.people_outline,
                  color: AppColors.cyberCyan,
                  route: '${AppRoutes.adminDashboard}/users',
                ),
                const SizedBox(height: 12),
                _buildActionModule(
                  context,
                  title: 'Curriculum & Mission Editor',
                  description: 'Manage months, weekly schedules, daily mission topics, and lab resources.',
                  icon: Icons.menu_book_outlined,
                  color: AppColors.matrixGreen,
                  route: '${AppRoutes.adminDashboard}/curriculum',
                ),
                const SizedBox(height: 12),
                _buildActionModule(
                  context,
                  title: 'Assessment & Test Bank',
                  description: 'Create weekly quizzes, MCQ questions, answer keys, and pass criteria.',
                  icon: Icons.assignment_turned_in_outlined,
                  color: AppColors.neonYellow,
                  route: '${AppRoutes.adminDashboard}/tests',
                ),

                const SizedBox(height: 24),

                // System Logs Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.matrixGreen),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'AUDIT LOG AUDITOR',
                            style: TextStyle(color: AppColors.matrixGreen, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '[2026-09-23 17:40:02 UTC] System integrity check: PASS\n[2026-09-23 17:42:15 UTC] PostgreSQL RLS policies confirmed active on 35 tables\n[2026-09-23 17:48:30 UTC] Automated streak recalculation trigger executed: 0 errors',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontFamily: 'monospace', height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, String subtitle, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              Icon(icon, color: color, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildActionModule(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return InkWell(
      onTap: () => context.push(route),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color.withValues(alpha: 0.4)),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
