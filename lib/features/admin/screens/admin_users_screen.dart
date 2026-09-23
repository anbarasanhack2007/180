import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../../services/supabase_service.dart';

final adminUsersListProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final data = await SupabaseService.profiles
        .select()
        .order('created_at', ascending: false);
    if (data.isNotEmpty) return List<Map<String, dynamic>>.from(data);
  } catch (_) {}

  // Fallback demo cadet roster
  return [
    {
      'id': 'u-1',
      'full_name': 'Anbarasan M',
      'email': 'anbarasan.cyber@example.com',
      'target_role': 'SOC Analyst & Incident Responder',
      'role': 'admin',
      'completed_days': 14,
      'streak': 6,
      'xp': 420,
    },
    {
      'id': 'u-2',
      'full_name': 'Kavya Raman',
      'email': 'kavya.r@example.com',
      'target_role': 'Web Penetration Tester',
      'role': 'student',
      'completed_days': 22,
      'streak': 12,
      'xp': 680,
    },
    {
      'id': 'u-3',
      'full_name': 'Rahul Verma',
      'email': 'rahul.v@example.com',
      'target_role': 'Cloud Security Engineer',
      'role': 'student',
      'completed_days': 8,
      'streak': 3,
      'xp': 230,
    },
    {
      'id': 'u-4',
      'full_name': 'Sneha Patel',
      'email': 'sneha.p@example.com',
      'target_role': 'Threat Hunter & Malware Analyst',
      'role': 'student',
      'completed_days': 31,
      'streak': 18,
      'xp': 950,
    },
  ];
});

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(adminUsersListProvider);

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
                            'CADET INTELLIGENCE',
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
                            'Student Cadets Roster',
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
                    IconButton(
                      icon: const Icon(Icons.refresh,
                          color: AppColors.textSecondary),
                      onPressed: () => ref.invalidate(adminUsersListProvider),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search cadet by name, email, or role...',
                    hintStyle: const TextStyle(color: AppColors.textMuted),
                    prefixIcon:
                        const Icon(Icons.search, color: AppColors.cyberCyan),
                    filled: true,
                    fillColor: AppColors.bgCard,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.borderColor)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.borderColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.cyberCyan)),
                  ),
                ),
              ),

              // Users List
              Expanded(
                child: usersAsync.when(
                  loading: () => const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.cyberCyan),
                  ),
                  error: (err, _) => Center(
                    child: Text('Error: $err',
                        style: const TextStyle(color: AppColors.neonRed)),
                  ),
                  data: (cadets) {
                    final filtered = cadets.where((u) {
                      return _searchQuery.isEmpty ||
                          (u['full_name'] ?? '')
                              .toString()
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()) ||
                          (u['email'] ?? '')
                              .toString()
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()) ||
                          (u['target_role'] ?? '')
                              .toString()
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase());
                    }).toList();

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final cadet = filtered[index];
                        final isAdmin = cadet['role'] == 'admin';

                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.bgCard,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.borderColor),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: isAdmin
                                        ? AppColors.neonPurple
                                            .withValues(alpha: 0.2)
                                        : AppColors.cyberCyan
                                            .withValues(alpha: 0.2),
                                    child: Icon(
                                      isAdmin
                                          ? Icons.admin_panel_settings
                                          : Icons.person,
                                      color: isAdmin
                                          ? AppColors.neonPurple
                                          : AppColors.cyberCyan,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              cadet['full_name'] ??
                                                  'Anonymous Cadet',
                                              style: const TextStyle(
                                                  color: AppColors.textPrimary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            const SizedBox(width: 8),
                                            if (isAdmin)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: AppColors.neonPurple
                                                      .withValues(alpha: 0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: const Text('ADMIN',
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .neonPurple,
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                          ],
                                        ),
                                        Text(
                                          cadet['email'] ?? '',
                                          style: const TextStyle(
                                              color: AppColors.textMuted,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Target: ${cadet['target_role'] ?? 'Cybersecurity Specialist'}',
                                style: const TextStyle(
                                    color: AppColors.cyberCyan,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 10),
                              const Divider(color: AppColors.borderColor),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildStatItem(
                                      'Day ${cadet['completed_days'] ?? 0}/180',
                                      'Sprint'),
                                  _buildStatItem(
                                      '${cadet['streak'] ?? 0} Days', 'Streak',
                                      isFire: true),
                                  _buildStatItem(
                                      '${cadet['xp'] ?? 0} XP', 'Reputation'),
                                ],
                              ),
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 200.ms, delay: (index * 30).ms);
                      },
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

  Widget _buildStatItem(String val, String label, {bool isFire = false}) {
    return Column(
      children: [
        Text(
          val,
          style: TextStyle(
            color: isFire ? AppColors.streakFire : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        Text(label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
      ],
    );
  }
}
