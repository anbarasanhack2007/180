import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../../services/supabase_service.dart';

final bookmarksListProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final userId = SupabaseService.currentUserId;
    if (userId != null) {
      final data = await SupabaseService.bookmarks
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      if (data.isNotEmpty) return List<Map<String, dynamic>>.from(data);
    }
  } catch (_) {}

  // Fallback demo bookmarks
  return [
    {
      'id': 'bm-1',
      'title': 'Day 12: Wireshark Packet Dissection & Filter Syntax',
      'item_type': 'mission',
      'day_number': 12,
      'notes': 'Revisit before Network+ / Sec+ exam',
      'created_at': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
    },
    {
      'id': 'bm-2',
      'title': 'PortSwigger Academy: Server-Side Request Forgery (SSRF)',
      'item_type': 'resource',
      'url': 'https://portswigger.net/web-security/ssrf',
      'notes': 'Great explanation of cloud metadata exploitation',
      'created_at': DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
    },
    {
      'id': 'bm-3',
      'title': 'TryHackMe: Linux Privilege Escalation Arena',
      'item_type': 'lab',
      'url': 'https://tryhackme.com/room/linprivesc',
      'notes': 'Practice SUID and cron job exploitation',
      'created_at': DateTime.now().subtract(const Duration(days: 6)).toIso8601String(),
    },
  ];
});

class BookmarksScreen extends ConsumerStatefulWidget {
  const BookmarksScreen({super.key});

  @override
  ConsumerState<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends ConsumerState<BookmarksScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final bookmarksAsync = ref.watch(bookmarksListProvider);
    final filterTabs = ['All', 'Missions', 'Resources', 'Labs'];

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
                      icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'QUICK VAULT',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.cyberCyan,
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            'Saved Bookmarks',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
                      onPressed: () => ref.invalidate(bookmarksListProvider),
                    ),
                  ],
                ),
              ),

              // Filter Chips
              SizedBox(
                height: 42,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: filterTabs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, idx) {
                    final tab = filterTabs[idx];
                    final isSelected = _selectedFilter == tab;
                    return ChoiceChip(
                      label: Text(tab),
                      selected: isSelected,
                      selectedColor: AppColors.cyberCyan.withValues(alpha: 0.2),
                      backgroundColor: AppColors.bgCard,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.cyberCyan : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      side: BorderSide(
                        color: isSelected ? AppColors.cyberCyan : AppColors.borderColor,
                      ),
                      onSelected: (_) => setState(() => _selectedFilter = tab),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // List of Bookmarks
              Expanded(
                child: bookmarksAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.cyberCyan),
                  ),
                  error: (err, _) => Center(
                    child: Text('Error: $err', style: const TextStyle(color: AppColors.neonRed)),
                  ),
                  data: (items) {
                    final filtered = items.where((bm) {
                      if (_selectedFilter == 'All') return true;
                      if (_selectedFilter == 'Missions') return bm['item_type'] == 'mission';
                      if (_selectedFilter == 'Resources') return bm['item_type'] == 'resource';
                      if (_selectedFilter == 'Labs') return bm['item_type'] == 'lab';
                      return true;
                    }).toList();

                    if (filtered.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.bookmark_border, size: 56, color: AppColors.textMuted),
                            const SizedBox(height: 12),
                            Text('No bookmarks yet', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary)),
                            const SizedBox(height: 4),
                            Text('Bookmark missions and labs to revisit later.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted)),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final bm = filtered[index];
                        final type = bm['item_type'] ?? 'general';

                        IconData icon;
                        Color typeColor;
                        switch (type) {
                          case 'mission':
                            icon = Icons.flag_outlined;
                            typeColor = AppColors.cyberCyan;
                            break;
                          case 'lab':
                            icon = Icons.terminal;
                            typeColor = AppColors.matrixGreen;
                            break;
                          case 'resource':
                            icon = Icons.language;
                            typeColor = AppColors.neonPurple;
                            break;
                          default:
                            icon = Icons.bookmark;
                            typeColor = AppColors.cyberCyan;
                        }

                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.bgCard,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.borderColor),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: typeColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: typeColor.withValues(alpha: 0.4)),
                                ),
                                child: Icon(icon, color: typeColor, size: 20),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      type.toUpperCase(),
                                      style: TextStyle(
                                        color: typeColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      bm['title'] ?? 'Bookmarked Item',
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (bm['notes'] != null && bm['notes'].toString().isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        bm['notes'],
                                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.cyberCyan),
                                onPressed: () async {
                                  if (bm['day_number'] != null) {
                                    context.push('${AppRoutes.home}/mission/${bm['day_number']}');
                                  } else if (bm['url'] != null) {
                                    final uri = Uri.parse(bm['url']);
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 200.ms, delay: (index * 30).ms);
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
}
