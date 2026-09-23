import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/cyber_background.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _selectedScope = 'All';

  // Master index of searchable platform items
  final List<Map<String, dynamic>> _masterIndex = [
    {
      'type': 'mission',
      'title': 'Day 1: Introduction to Cybersecurity & Threat Landscapes',
      'subtitle': 'Confidentiality, Integrity, Availability (CIA Triad)',
      'day_number': 1,
      'category': 'Missions',
    },
    {
      'type': 'mission',
      'title': 'Day 12: Wireshark Packet Dissection & Filter Expressions',
      'subtitle': 'Analyzing TCP handshakes, DNS queries, and ARP requests',
      'day_number': 12,
      'category': 'Missions',
    },
    {
      'type': 'mission',
      'title': 'Day 35: Linux File Permissions, SUID & Capabilities',
      'subtitle':
          'chmod, chown, SUID/SGID bits and privilege escalation vectors',
      'day_number': 35,
      'category': 'Missions',
    },
    {
      'type': 'mission',
      'title': 'Day 68: SQL Injection — UNION & Error-Based Payloads',
      'subtitle': 'PortSwigger Web Security Academy SQLi Lab walkthrough',
      'day_number': 68,
      'category': 'Missions',
    },
    {
      'type': 'project',
      'title': 'Project 1: Raw Packet Sniffer & Protocol Analyzer',
      'subtitle': 'Python, Scapy, Sockets, PCAP export',
      'project_id': 'proj-1',
      'category': 'Projects',
    },
    {
      'type': 'project',
      'title': 'Project 2: Automated Multi-threaded Port Scanner',
      'subtitle': 'SYN Scanning, Banner Grabbing, Service Fingerprinting',
      'project_id': 'proj-2',
      'category': 'Projects',
    },
    {
      'type': 'project',
      'title': 'Project 3: Vulnerability Scanner & Exploit Correlator',
      'subtitle': 'Web Crawler, Header Security Checker, CVE API Matcher',
      'project_id': 'proj-3',
      'category': 'Projects',
    },
    {
      'type': 'lab',
      'title': 'TryHackMe: Pre-Security & Network Fundamentals',
      'subtitle': 'Interactive browser terminal and virtual target network',
      'route': AppRoutes.labs,
      'category': 'Labs',
    },
    {
      'type': 'lab',
      'title': 'PortSwigger: SQLi & Cross-Site Scripting (XSS)',
      'subtitle': 'Hands-on live vulnerable web apps',
      'route': AppRoutes.labs,
      'category': 'Labs',
    },
    {
      'type': 'interview',
      'title': 'TCP 3-Way Handshake & SYN Flood Defense',
      'subtitle': 'Networking Technical Interview Q&A',
      'route': AppRoutes.interview,
      'category': 'Interview',
    },
    {
      'type': 'interview',
      'title': 'Differentiating False Positives in SIEM Detection',
      'subtitle': 'SOC Analyst Incident Response Q&A',
      'route': AppRoutes.interview,
      'category': 'Interview',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scopes = ['All', 'Missions', 'Projects', 'Labs', 'Interview'];

    final results = _masterIndex.where((item) {
      final matchesScope =
          _selectedScope == 'All' || item['category'] == _selectedScope;
      final matchesQuery = _query.isEmpty ||
          item['title']
              .toString()
              .toLowerCase()
              .contains(_query.toLowerCase()) ||
          item['subtitle']
              .toString()
              .toLowerCase()
              .contains(_query.toLowerCase());
      return matchesScope && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CyberBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Input Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: AppColors.textPrimary),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        onChanged: (v) => setState(() => _query = v),
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Search curriculum, projects, labs...',
                          hintStyle:
                              const TextStyle(color: AppColors.textMuted),
                          prefixIcon: const Icon(Icons.search,
                              color: AppColors.cyberCyan),
                          suffixIcon: _query.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: AppColors.textMuted),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _query = '');
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: AppColors.bgCard,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: AppColors.borderColor)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: AppColors.borderColor)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: AppColors.cyberCyan)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Filter scope chips
              SizedBox(
                height: 40,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: scopes.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, idx) {
                    final scope = scopes[idx];
                    final isSelected = _selectedScope == scope;
                    return ChoiceChip(
                      label: Text(scope),
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
                              : AppColors.borderColor),
                      onSelected: (_) => setState(() => _selectedScope = scope),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Results Count & List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${results.length} INTEL NODES FOUND',
                  style: const TextStyle(
                      color: AppColors.cyberCyan,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2),
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: results.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off,
                                size: 56, color: AppColors.textMuted),
                            const SizedBox(height: 12),
                            Text('No matching intel found',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: results.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = results[index];
                          final type = item['type'];

                          Color typeColor = AppColors.cyberCyan;
                          IconData icon = Icons.article;
                          if (type == 'mission') {
                            typeColor = AppColors.cyberCyan;
                            icon = Icons.flag_outlined;
                          } else if (type == 'project') {
                            typeColor = AppColors.neonPurple;
                            icon = Icons.folder_special_outlined;
                          } else if (type == 'lab') {
                            typeColor = AppColors.matrixGreen;
                            icon = Icons.terminal;
                          } else if (type == 'interview') {
                            typeColor = AppColors.neonYellow;
                            icon = Icons.quiz_outlined;
                          }

                          return InkWell(
                            onTap: () {
                              if (item['day_number'] != null) {
                                context.push(
                                    '${AppRoutes.home}/mission/${item['day_number']}');
                              } else if (item['project_id'] != null) {
                                context.push(
                                    '${AppRoutes.projects}/${item['project_id']}');
                              } else if (item['route'] != null) {
                                context.push(item['route']);
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.bgCard,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: AppColors.borderColor),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: typeColor.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child:
                                        Icon(icon, color: typeColor, size: 18),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['title'] ?? '',
                                          style: const TextStyle(
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          item['subtitle'] ?? '',
                                          style: const TextStyle(
                                              color: AppColors.textMuted,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios,
                                      size: 14, color: AppColors.textMuted),
                                ],
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 150.ms, delay: (index * 20).ms);
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
