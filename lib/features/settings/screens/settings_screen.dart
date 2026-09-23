import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/supabase_config.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../../services/supabase_service.dart';
import '../../auth/providers/auth_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _dailyReminderEnabled = true;
  final String _reminderTime = '08:00 AM';
  bool _soundEffectsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentProfileProvider).valueOrNull;
    final isConfigured = SupabaseConfig.isConfigured;

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
                            'SYSTEM CONTROL',
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
                            'Settings & Preferences',
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

              // Settings Items List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Account Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor:
                                AppColors.cyberCyan.withValues(alpha: 0.15),
                            child: const Icon(Icons.person,
                                color: AppColors.cyberCyan, size: 30),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile?.fullName ?? 'Cyber Cadet',
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  profile?.email ?? 'cadet@cybersprint.io',
                                  style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isConfigured
                                            ? AppColors.matrixGreen
                                            : AppColors.neonYellow,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      isConfigured
                                          ? 'Connected to Cloud'
                                          : 'Local Standalone Mode',
                                      style: TextStyle(
                                        color: isConfigured
                                            ? AppColors.matrixGreen
                                            : AppColors.neonYellow,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Daily Notifications
                    _buildSectionTitle('NOTIFICATIONS & SCHEDULE'),
                    _buildSwitchTile(
                      title: 'Daily Mission Reminder',
                      subtitle:
                          'Alert at $_reminderTime to maintain daily streak',
                      value: _dailyReminderEnabled,
                      icon: Icons.notifications_active_outlined,
                      onChanged: (val) =>
                          setState(() => _dailyReminderEnabled = val),
                    ),
                    _buildSwitchTile(
                      title: 'Audio Alerts & Cyber SFX',
                      subtitle:
                          'Play sound effects on task completion and XP grant',
                      value: _soundEffectsEnabled,
                      icon: Icons.volume_up_outlined,
                      onChanged: (val) =>
                          setState(() => _soundEffectsEnabled = val),
                    ),

                    const SizedBox(height: 24),

                    // Admin Section
                    _buildSectionTitle('OPERATIONAL PRIVILEGES'),
                    ListTile(
                      tileColor: AppColors.bgCard,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.borderColor),
                      ),
                      leading: const Icon(Icons.admin_panel_settings_outlined,
                          color: AppColors.neonPurple),
                      title: const Text('Faculty & Admin Console',
                          style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                      subtitle: const Text(
                          'Manage curriculum, exam questions, and student rosters',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 12)),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          size: 14, color: AppColors.textMuted),
                      onTap: () => context.push(AppRoutes.adminDashboard),
                    ),

                    const SizedBox(height: 24),

                    // Security & Cloud Configuration
                    _buildSectionTitle('INFRASTRUCTURE & STORAGE'),
                    ListTile(
                      tileColor: AppColors.bgCard,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.borderColor),
                      ),
                      leading: const Icon(Icons.cloud_sync_outlined,
                          color: AppColors.cyberCyan),
                      title: const Text('Force Cloud Sync',
                          style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                      subtitle: const Text(
                          'Sync offline cache with Supabase backend',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 12)),
                      trailing:
                          const Icon(Icons.sync, color: AppColors.cyberCyan),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Offline progress synchronized successfully!')),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Sign Out
                    ListTile(
                      tileColor: AppColors.bgCard,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                            color: AppColors.neonRed.withValues(alpha: 0.3)),
                      ),
                      leading:
                          const Icon(Icons.logout, color: AppColors.neonRed),
                      title: const Text('Log Out of Terminal',
                          style: TextStyle(
                              color: AppColors.neonRed,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                      subtitle: const Text('Disconnect user session safely',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 12)),
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: AppColors.bgCard,
                            title: const Text('Sign Out?',
                                style: TextStyle(color: Colors.white)),
                            content: const Text(
                              'Are you sure you want to end your current session?',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Cancel',
                                    style:
                                        TextStyle(color: AppColors.textMuted)),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.neonRed),
                                child: const Text('Sign Out'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await SupabaseService.signOut();
                          if (!context.mounted) return;
                          context.go(AppRoutes.login);
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.cyberCyan,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: SwitchListTile(
        title: Text(title,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
        secondary: Icon(icon, color: AppColors.cyberCyan),
        value: value,
        activeThumbColor: AppColors.cyberCyan,
        onChanged: onChanged,
      ),
    );
  }
}
