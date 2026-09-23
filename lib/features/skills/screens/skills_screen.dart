import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../../services/supabase_service.dart';

final allSkillsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final data = await SupabaseService.skills.select().order('sort_order');
  return List<Map<String, dynamic>>.from(data as List);
});

final userSkillsMapProvider =
    FutureProvider<Map<String, Map<String, dynamic>>>((ref) async {
  final userId = SupabaseService.currentUserId;
  if (userId == null) return {};
  final data = await SupabaseService.userSkills.select().eq('user_id', userId);
  final map = <String, Map<String, dynamic>>{};
  for (final s in data as List) {
    map[s['skill_id'] as String] = s as Map<String, dynamic>;
  }
  return map;
});

class SkillsScreen extends ConsumerWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skillsAsync = ref.watch(allSkillsProvider);
    final userSkillsAsync = ref.watch(userSkillsMapProvider);

    final categories = [
      'Foundation',
      'Programming',
      'Offensive',
      'Defensive',
      'Career'
    ];
    final categoryIcons = {
      'Foundation': Icons.computer_outlined,
      'Programming': Icons.code_outlined,
      'Offensive': Icons.security_outlined,
      'Defensive': Icons.shield_outlined,
      'Career': Icons.work_outline,
    };
    final categoryColors = {
      'Foundation': AppColors.cyberCyan,
      'Programming': AppColors.cyberBlue,
      'Offensive': AppColors.cyberRed,
      'Defensive': AppColors.cyberGreen,
      'Career': AppColors.cyberPurple,
    };

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('SKILLS'),
        centerTitle: true,
      ),
      body: CyberBackground(
        child: skillsAsync.when(
          data: (skills) => userSkillsAsync.when(
            data: (userSkills) => ListView(
              padding: const EdgeInsets.all(16),
              children: categories.map((cat) {
                final catSkills =
                    skills.where((s) => s['category'] == cat).toList();
                if (catSkills.isEmpty) return const SizedBox.shrink();
                final color = categoryColors[cat] ?? AppColors.cyberCyan;
                final icon = categoryIcons[cat] ?? Icons.star;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(icon, color: color, size: 16),
                      const SizedBox(width: 6),
                      Text(cat.toUpperCase(),
                          style: TextStyle(
                              color: color,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5)),
                    ]),
                    const SizedBox(height: 8),
                    ...catSkills.map((skill) {
                      final us = userSkills[skill['id'] as String];
                      final status = us?['status'] as String? ?? 'not_started';
                      final progress =
                          (us?['progress'] as int? ?? 0).toDouble() / 100;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Expanded(
                                  child: Text(skill['name'] as String? ?? '',
                                      style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600))),
                              _statusBadge(status, color),
                            ]),
                            if ((skill['description'] as String?)?.isNotEmpty ??
                                false) ...[
                              const SizedBox(height: 4),
                              Text(skill['description'] as String,
                                  style: const TextStyle(
                                      color: AppColors.textHint, fontSize: 12),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                            ],
                            const SizedBox(height: 8),
                            Row(children: [
                              Expanded(
                                  child: LinearProgressIndicator(
                                      value: progress,
                                      backgroundColor: AppColors.progressBg,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(color),
                                      minHeight: 4)),
                              const SizedBox(width: 8),
                              Text('${(progress * 100).toInt()}%',
                                  style: TextStyle(
                                      color: color,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ]),
                            const SizedBox(height: 8),
                            Wrap(
                                spacing: 6,
                                children: [
                                  'not_started',
                                  'learning',
                                  'practicing',
                                  'completed'
                                ].map((s) {
                                  final selected = status == s;
                                  return GestureDetector(
                                    onTap: () async {
                                      final userId =
                                          SupabaseService.currentUserId;
                                      if (userId == null) return;
                                      await SupabaseService.userSkills.upsert({
                                        'user_id': userId,
                                        'skill_id': skill['id'],
                                        'status': s,
                                        'progress': s == 'completed'
                                            ? 100
                                            : (s == 'practicing'
                                                ? 75
                                                : (s == 'learning' ? 25 : 0)),
                                        'updated_at':
                                            DateTime.now().toIso8601String(),
                                      });
                                      ref.invalidate(userSkillsMapProvider);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: selected
                                            ? color.withValues(alpha: 0.15)
                                            : AppColors.bgElevated,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            color: selected
                                                ? color
                                                : Colors.transparent),
                                      ),
                                      child: Text(s.replaceAll('_', ' '),
                                          style: TextStyle(
                                              color: selected
                                                  ? color
                                                  : AppColors.textHint,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  );
                                }).toList()),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ),
            loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.cyberCyan)),
            error: (e, _) => const Center(child: Text('Error loading skills')),
          ),
          loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.cyberCyan)),
          error: (e, _) => const Center(child: Text('Error loading skills')),
        ),
      ),
    );
  }

  Widget _statusBadge(String status, Color color) {
    final labels = {
      'not_started': 'NOT STARTED',
      'learning': 'LEARNING',
      'practicing': 'PRACTICING',
      'completed': 'DONE'
    };
    final colors = {
      'not_started': AppColors.textHint,
      'learning': AppColors.cyberBlue,
      'practicing': AppColors.cyberOrange,
      'completed': AppColors.cyberGreen,
    };
    final c = colors[status] ?? AppColors.textHint;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: c.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(4)),
      child: Text(labels[status] ?? status.toUpperCase(),
          style: TextStyle(
              color: c,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5)),
    );
  }
}
