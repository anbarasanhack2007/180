import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../dashboard/providers/dashboard_providers.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(userProgressSummaryProvider).valueOrNull;

    final completedDays = progress?.completedDays ?? 12;
    final totalHours = (progress?.totalStudyMinutes ?? 2100) ~/ 60;
    const testsCompleted = 3;
    const avgScore = 84.5;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CyberBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
                            'TELEMETRY & METRICS',
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
                            'Study Analytics Radar',
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

              // Analytics Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top KPI Metric Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricTile(
                              title: 'Total Study',
                              value: '${totalHours}h',
                              subtitle: 'Logged hours',
                              color: AppColors.cyberCyan,
                              icon: Icons.timer_outlined,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildMetricTile(
                              title: 'Days Finished',
                              value: '$completedDays/180',
                              subtitle:
                                  '${((completedDays / 180) * 100).toStringAsFixed(1)}% complete',
                              color: AppColors.matrixGreen,
                              icon: Icons.check_circle_outline,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricTile(
                              title: 'Tests Taken',
                              value: '$testsCompleted',
                              subtitle: 'Quizzes passed',
                              color: AppColors.neonPurple,
                              icon: Icons.quiz_outlined,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildMetricTile(
                              title: 'Average Score',
                              value: '${avgScore.toStringAsFixed(0)}%',
                              subtitle: 'Accuracy rate',
                              color: AppColors.neonYellow,
                              icon: Icons.grade_outlined,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Weekly Study Time Chart (Bar Chart)
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
                            const Text(
                              'STUDY INTENSITY (LAST 7 DAYS)',
                              style: TextStyle(
                                color: AppColors.cyberCyan,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 160,
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: 5,
                                  barTouchData: BarTouchData(enabled: false),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (val, meta) {
                                          const days = [
                                            'M',
                                            'T',
                                            'W',
                                            'T',
                                            'F',
                                            'S',
                                            'S'
                                          ];
                                          final idx = val.toInt();
                                          if (idx >= 0 && idx < days.length) {
                                            return Text(days[idx],
                                                style: const TextStyle(
                                                    color: AppColors.textMuted,
                                                    fontSize: 11));
                                          }
                                          return const SizedBox.shrink();
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 28,
                                        getTitlesWidget: (val, meta) {
                                          return Text('${val.toInt()}h',
                                              style: const TextStyle(
                                                  color: AppColors.textMuted,
                                                  fontSize: 10));
                                        },
                                      ),
                                    ),
                                    topTitles: const AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                    rightTitles: const AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                  ),
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    getDrawingHorizontalLine: (val) =>
                                        const FlLine(
                                            color: AppColors.borderColor,
                                            strokeWidth: 0.8),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  barGroups: [
                                    _makeBarGroup(0, 2.5),
                                    _makeBarGroup(1, 3.0),
                                    _makeBarGroup(2, 1.8),
                                    _makeBarGroup(3, 4.2),
                                    _makeBarGroup(4, 2.8),
                                    _makeBarGroup(5, 3.5),
                                    _makeBarGroup(6, 2.0),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 300.ms),

                      const SizedBox(height: 20),

                      // Domain Mastery Bars
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
                            const Text(
                              'CORE CYBER DOMAIN MASTERY',
                              style: TextStyle(
                                color: AppColors.cyberCyan,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 14),
                            _buildDomainProgress('Networking & Packet Analysis',
                                0.65, AppColors.cyberCyan),
                            const SizedBox(height: 10),
                            _buildDomainProgress('Linux & Shell Scripting',
                                0.55, AppColors.matrixGreen),
                            const SizedBox(height: 10),
                            _buildDomainProgress('Web Security & OWASP Top 10',
                                0.40, AppColors.neonPurple),
                            const SizedBox(height: 10),
                            _buildDomainProgress(
                                'SOC Operations & Log Telemetry',
                                0.30,
                                AppColors.neonYellow),
                            const SizedBox(height: 10),
                            _buildDomainProgress('Offensive Exploit Crafting',
                                0.20, AppColors.neonRed),
                          ],
                        ),
                      ).animate().fadeIn(duration: 350.ms),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.cyberCyan,
          width: 14,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
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
              Text(title,
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 11)),
              Icon(icon, color: color, size: 16),
            ],
          ),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(subtitle,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildDomainProgress(String name, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
            Text('${(progress * 100).toInt()}%',
                style: TextStyle(
                    color: color, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.bgSurface,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
