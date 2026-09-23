import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../../services/supabase_service.dart';

final notesListProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final userId = SupabaseService.currentUserId;
    if (userId != null) {
      final data = await SupabaseService.notes
          .select()
          .eq('user_id', userId)
          .order('is_pinned', ascending: false)
          .order('updated_at', ascending: false);
      if (data.isNotEmpty) return List<Map<String, dynamic>>.from(data);
    }
  } catch (_) {}

  // Fallback demo notes
  return [
    {
      'id': 'note-1',
      'title': 'TCP 3-Way Handshake & Wireshark Filter Cheat-Sheet',
      'content': 'SYN -> SYN-ACK -> ACK.\\nFilter in Wireshark: tcp.flags.syn==1 and tcp.flags.ack==0.\\nLook for unusual RST packets indicating firewalls or resets.',
      'tags': ['networking', 'wireshark'],
      'is_pinned': true,
      'updated_at': DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
    },
    {
      'id': 'note-2',
      'title': 'SQL Injection Error-Based & Union Payloads',
      'content': "' UNION SELECT null, username, password FROM users-- -\\nRemember to match columns with ORDER BY 1, 2, 3...",
      'tags': ['websec', 'sqli'],
      'is_pinned': false,
      'updated_at': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
    },
    {
      'id': 'note-3',
      'title': 'Linux Privilege Escalation SUID Check',
      'content': 'find / -perm -u=s -type f 2>/dev/null\\nCheck GTFOBins for find, vim, cp, bash with SUID bits set.',
      'tags': ['linux', 'privesc'],
      'is_pinned': false,
      'updated_at': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
    },
  ];
});

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(notesListProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.cyberCyan,
        foregroundColor: AppColors.bgPrimary,
        onPressed: () => context.push('${AppRoutes.notes}/create'),
        icon: const Icon(Icons.add),
        label: const Text('New Note', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: CyberBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top App Bar
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
                            'FIELD INTELLIGENCE',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.cyberCyan,
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            'Research & Study Notes',
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
                      onPressed: () => ref.invalidate(notesListProvider),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search notes, payloads, commands...',
                    hintStyle: const TextStyle(color: AppColors.textMuted),
                    prefixIcon: const Icon(Icons.search, color: AppColors.cyberCyan),
                    filled: true,
                    fillColor: AppColors.bgCard,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.cyberCyan),
                    ),
                  ),
                ),
              ),

              // Notes List
              Expanded(
                child: notesAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.cyberCyan),
                  ),
                  error: (err, _) => Center(
                    child: Text('Error loading notes: $err', style: const TextStyle(color: AppColors.neonRed)),
                  ),
                  data: (notes) {
                    final filtered = notes.where((note) {
                      final matchesSearch = _searchQuery.isEmpty ||
                          (note['title'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          (note['content'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase());
                      return matchesSearch;
                    }).toList();

                    if (filtered.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.note_alt_outlined, size: 56, color: AppColors.textMuted),
                            const SizedBox(height: 12),
                            Text('No notes recorded yet', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary)),
                            const SizedBox(height: 4),
                            Text('Document your commands, takeaways and writeups here.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted)),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final note = filtered[index];
                        final isPinned = note['is_pinned'] == true;
                        final tags = (note['tags'] as List?)?.map((e) => e.toString()).toList() ?? [];

                        return InkWell(
                          onTap: () => context.push('${AppRoutes.notes}/${note['id']}'),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.bgCard,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isPinned ? AppColors.cyberCyan.withValues(alpha: 0.6) : AppColors.borderColor,
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (isPinned) ...[
                                      const Icon(Icons.push_pin, size: 16, color: AppColors.cyberCyan),
                                      const SizedBox(width: 6),
                                    ],
                                    Expanded(
                                      child: Text(
                                        note['title'] ?? 'Untitled Note',
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  note['content'] ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                                if (tags.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: tags.map((tag) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.cyberCyan.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          '#$tag',
                                          style: const TextStyle(
                                            color: AppColors.cyberCyan,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ],
                            ),
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
