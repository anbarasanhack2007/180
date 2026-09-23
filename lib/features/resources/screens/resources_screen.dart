import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../../services/supabase_service.dart';

final resourcesFilterProvider = StateProvider<String>((ref) => 'All');
final resourcesSearchQueryProvider = StateProvider<String>((ref) => '');

final allResourcesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final data = await SupabaseService.resources
        .select()
        .order('category', ascending: true);
    if (data.isNotEmpty) return List<Map<String, dynamic>>.from(data);
  } catch (_) {}

  // Fallback production resources curated for the 180-day cybersecurity curriculum
  return [
    {
      'id': 'res-1',
      'title': 'Professor Messer CompTIA Security+ SY0-701 Training Course',
      'category': 'Certification',
      'type': 'video',
      'platform': 'YouTube',
      'url':
          'https://www.youtube.com/playlist?list=PLG49S3nxzAnl4QDVqK-hOnoqcSKEIDDuv',
      'description':
          'Complete video training series covering core cybersecurity principles, threats, attacks, vulnerabilities, and architecture.',
      'icon': 'school',
    },
    {
      'id': 'res-2',
      'title': 'TryHackMe: Pre-Security & Complete Beginner Path',
      'category': 'Hands-on Labs',
      'type': 'lab',
      'platform': 'TryHackMe',
      'url': 'https://tryhackme.com/path/outline/beginner',
      'description':
          'Interactive cybersecurity rooms covering networking, Linux fundamentals, web application security, and basic penetration testing.',
      'icon': 'terminal',
    },
    {
      'id': 'res-3',
      'title': 'PortSwigger Web Security Academy',
      'category': 'Web Security',
      'type': 'lab',
      'platform': 'PortSwigger',
      'url': 'https://portswigger.net/web-security',
      'description':
          'Free web security training containing theory and interactive practice labs covering SQL injection, XSS, CSRF, and SSRF.',
      'icon': 'language',
    },
    {
      'id': 'res-4',
      'title': 'NetworkChuck: CCNA & Practical Networking',
      'category': 'Networking',
      'type': 'video',
      'platform': 'YouTube',
      'url': 'https://www.youtube.com/@NetworkChuck',
      'description':
          'Hands-on Wireshark packet analysis, Subnetting, TCP/IP deep-dives, and router/firewall configuration tutorials.',
      'icon': 'hub',
    },
    {
      'id': 'res-5',
      'title': 'John Hammond Cyber Tutorials & CTF Walkthroughs',
      'category': 'Offensive Security',
      'type': 'video',
      'platform': 'YouTube',
      'url': 'https://www.youtube.com/@_JohnHammond',
      'description':
          'Malware analysis breakdowns, CTF challenge walk-throughs, threat hunting, and modern attack tradecraft.',
      'icon': 'security',
    },
    {
      'id': 'res-6',
      'title': 'OWASP Top 10 Security Risks Documentation',
      'category': 'Web Security',
      'type': 'doc',
      'platform': 'OWASP',
      'url': 'https://owasp.org/www-project-top-ten/',
      'description':
          'Official standard awareness document for developers and web application security pros.',
      'icon': 'description',
    },
    {
      'id': 'res-7',
      'title': 'OverTheWire: Bandit Wargame',
      'category': 'Linux',
      'type': 'lab',
      'platform': 'OverTheWire',
      'url': 'https://overthewire.org/wargames/bandit/',
      'description':
          'A gamified SSH and command-line wargame geared for learning Linux commands and basic security mechanisms.',
      'icon': 'code',
    },
    {
      'id': 'res-8',
      'title': 'IppSec: HackTheBox Walkthroughs',
      'category': 'Offensive Security',
      'type': 'video',
      'platform': 'YouTube',
      'url': 'https://www.youtube.com/@ippsec',
      'description':
          'Legendary step-by-step video dissections of HackTheBox machines with OSCP-level enumeration and privilege escalation.',
      'icon': 'ondemand_video',
    },
  ];
});

class ResourcesScreen extends ConsumerWidget {
  const ResourcesScreen({super.key});

  IconData _getIconData(String? icon) {
    switch (icon) {
      case 'school':
        return Icons.school;
      case 'terminal':
        return Icons.terminal;
      case 'language':
        return Icons.language;
      case 'hub':
        return Icons.hub;
      case 'security':
        return Icons.security;
      case 'code':
        return Icons.code;
      case 'ondemand_video':
        return Icons.ondemand_video;
      default:
        return Icons.description;
    }
  }

  Color _getCategoryColor(String? category) {
    switch (category) {
      case 'Web Security':
        return AppColors.cyberCyan;
      case 'Hands-on Labs':
        return AppColors.matrixGreen;
      case 'Offensive Security':
        return AppColors.neonRed;
      case 'Certification':
        return AppColors.neonYellow;
      case 'Networking':
        return AppColors.neonPurple;
      case 'Linux':
        return const Color(0xFFFF9100);
      default:
        return AppColors.cyberCyan;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourcesAsync = ref.watch(allResourcesProvider);
    final selectedFilter = ref.watch(resourcesFilterProvider);
    final searchQuery = ref.watch(resourcesSearchQueryProvider);

    final categories = [
      'All',
      'Web Security',
      'Hands-on Labs',
      'Offensive Security',
      'Certification',
      'Networking',
      'Linux'
    ];

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
                            'CURATED ARSENAL',
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
                            'Resources & Field Manuals',
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

              // Search Box
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  onChanged: (val) => ref
                      .read(resourcesSearchQueryProvider.notifier)
                      .state = val,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search labs, walkthroughs, docs...',
                    hintStyle: const TextStyle(color: AppColors.textMuted),
                    prefixIcon:
                        const Icon(Icons.search, color: AppColors.cyberCyan),
                    filled: true,
                    fillColor: AppColors.bgCard,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.cyberCyan),
                    ),
                  ),
                ),
              ),

              // Category Filter Chips
              SizedBox(
                height: 40,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, idx) {
                    final cat = categories[idx];
                    final isSelected = selectedFilter == cat;
                    return ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: AppColors.cyberCyan.withValues(alpha: 0.2),
                      backgroundColor: AppColors.bgCard,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppColors.cyberCyan
                            : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.cyberCyan
                            : AppColors.borderColor,
                      ),
                      onSelected: (_) => ref
                          .read(resourcesFilterProvider.notifier)
                          .state = cat,
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Resources List
              Expanded(
                child: resourcesAsync.when(
                  loading: () => const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.cyberCyan),
                  ),
                  error: (err, _) => Center(
                    child: Text('Error loading resources: $err',
                        style: const TextStyle(color: AppColors.neonRed)),
                  ),
                  data: (items) {
                    final filtered = items.where((res) {
                      final matchesFilter = selectedFilter == 'All' ||
                          res['category'] == selectedFilter;
                      final matchesSearch = searchQuery.isEmpty ||
                          (res['title'] ?? '')
                              .toString()
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()) ||
                          (res['description'] ?? '')
                              .toString()
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()) ||
                          (res['platform'] ?? '')
                              .toString()
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase());
                      return matchesFilter && matchesSearch;
                    }).toList();

                    if (filtered.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.filter_list_off,
                                size: 48, color: AppColors.textMuted),
                            const SizedBox(height: 12),
                            Text('No resources match your search',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final res = filtered[index];
                        final catColor = _getCategoryColor(res['category']);

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
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: catColor.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color:
                                              catColor.withValues(alpha: 0.4)),
                                    ),
                                    child: Icon(_getIconData(res['icon']),
                                        color: catColor, size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          res['platform'] ?? 'Web Resource',
                                          style: TextStyle(
                                            color: catColor,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                        Text(
                                          res['title'] ?? 'Cyber Resource',
                                          style: const TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                res['description'] ?? '',
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                    height: 1.4),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.bgSurface,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          color: AppColors.borderColor),
                                    ),
                                    child: Text(
                                      res['category'] ?? 'General',
                                      style: const TextStyle(
                                          color: AppColors.textMuted,
                                          fontSize: 11),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      final urlStr = res['url'] ?? '';
                                      if (urlStr.isNotEmpty) {
                                        final uri = Uri.parse(urlStr);
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri,
                                              mode: LaunchMode
                                                  .externalApplication);
                                        }
                                      }
                                    },
                                    icon:
                                        const Icon(Icons.open_in_new, size: 14),
                                    label: const Text('Launch Resource',
                                        style: TextStyle(fontSize: 12)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          catColor.withValues(alpha: 0.15),
                                      foregroundColor: catColor,
                                      elevation: 0,
                                      side: BorderSide(
                                          color:
                                              catColor.withValues(alpha: 0.4)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 250.ms, delay: (index * 40).ms);
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
