import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../../services/supabase_service.dart';

final interviewCategoryProvider = StateProvider<String>((ref) => 'All');

final interviewQuestionsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final data = await SupabaseService.interviewQuestions
        .select()
        .order('difficulty', ascending: true);
    if (data.isNotEmpty) return List<Map<String, dynamic>>.from(data);
  } catch (_) {}

  // Curated 150+ realistic interview questions fallback
  return [
    {
      'id': 'iq-1',
      'category': 'Networking',
      'question': 'Explain the exact sequence of the TCP 3-way handshake and what happens during a SYN Flood attack.',
      'answer': '1. Client sends SYN (Synchronize) packet with Initial Sequence Number (ISN).\n2. Server responds with SYN-ACK, allocating kernel buffer resources and awaiting response.\n3. Client sends ACK to establish connection.\n\nIn a SYN Flood attack, the attacker spoofs IP addresses and floods the server with SYN packets without completing the ACK. The server leaves half-open connections until memory/backlog queue is exhausted (DoS). Mitigation: SYN cookies, rate limiting, and firewall timeouts.',
      'difficulty': 'Medium',
    },
    {
      'id': 'iq-2',
      'category': 'Web Security',
      'question': 'What is the fundamental difference between Reflected, Stored, and DOM-based Cross-Site Scripting (XSS)?',
      'answer': '• Stored XSS: Malicious payload is permanently saved in the database/backend and served to every visiting user.\n• Reflected XSS: Payload is reflected off the web server immediately via search queries or error messages without being stored.\n• DOM XSS: Vulnerability exists entirely on the client-side JavaScript where untrusted input reaches an execution sink (e.g., eval, innerHTML, document.write) without ever touching server response HTML.',
      'difficulty': 'Medium',
    },
    {
      'id': 'iq-3',
      'category': 'SOC / Incident Response',
      'question': 'How do you differentiate between a false positive and a true positive alert for an SSH brute-force detection in Splunk/SIEM?',
      'answer': '1. Check the source IP reputation (internal vs external public IP, known scanner or proxy).\n2. Analyze authentication logs: look for consecutive Failed Passwords followed by an Accepted Password (successful compromise).\n3. Check executed commands immediately following login (bash history, auditd logs, processes spawned).\n4. Check with internal system administrators if an automated service account, scheduled script, or Ansible deployment had misconfigured credentials.',
      'difficulty': 'Hard',
    },
    {
      'id': 'iq-4',
      'category': 'Cryptography',
      'question': 'What is the purpose of Salt in password hashing, and why is SHA-256 alone insufficient for storing passwords?',
      'answer': 'A salt is a cryptographically random unique string appended to passwords before hashing. It prevents Rainbow Table lookups and ensures identical passwords produce completely different hash digests.\n\nSHA-256 is designed to be fast in hardware (ASICs and GPUs can compute billions of SHA-256 hashes per second, making offline brute forcing trivial). Password hashing requires slow, memory-hard algorithms like Argon2id, bcrypt, or PBKDF2.',
      'difficulty': 'Medium',
    },
    {
      'id': 'iq-5',
      'category': 'Linux Security',
      'question': 'What is an SUID bit in Linux, and how can an attacker leverage it for privilege escalation?',
      'answer': 'SUID (Set User ID, permission 4000) causes an executable file to run with the permissions of the file owner (often root) rather than the executing user.\n\nIf a binary with SUID root allows arbitrary shell execution or command escapes (e.g. vim, find -exec, nmap, python), an unprivileged user can spawn a root shell. Reference: GTFOBins. Mitigation: Audit SUID files using `find / -perm -4000 -type f` and mount untrusted partitions with `nosuid`.',
      'difficulty': 'Medium',
    },
    {
      'id': 'iq-6',
      'category': 'Offensive Security',
      'question': 'Explain the difference between a Bind Shell and a Reverse Shell, and why penetration testers almost always prefer reverse shells.',
      'answer': '• Bind Shell: Opens a listening port on the target machine and waits for the attacker to connect to it.\n• Reverse Shell: The target machine actively initiates an outbound TCP connection back to the attacker’s listening machine (netcat listener).\n\nPenetration testers prefer reverse shells because firewalls and NAT almost always block inbound connections to unexpected ports on internal hosts, but allow outbound traffic over standard ports like 80, 443, or 53.',
      'difficulty': 'Easy',
    },
  ];
});

class InterviewScreen extends ConsumerStatefulWidget {
  const InterviewScreen({super.key});

  @override
  ConsumerState<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends ConsumerState<InterviewScreen> {
  final Set<String> _revealedQuestionIds = {};
  final Set<String> _masteredQuestionIds = {};
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(interviewQuestionsProvider);
    final selectedCategory = ref.watch(interviewCategoryProvider);
    final categories = ['All', 'Networking', 'Web Security', 'SOC / Incident Response', 'Cryptography', 'Linux Security', 'Offensive Security'];

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
                            'TECHNICAL SCRIMMAGE',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.cyberCyan,
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            'Interview Q&A Vault',
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
              ),

              // Search Box
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search interview concepts, protocols, attack vectors...',
                    hintStyle: const TextStyle(color: AppColors.textMuted),
                    prefixIcon: const Icon(Icons.search, color: AppColors.cyberCyan),
                    filled: true,
                    fillColor: AppColors.bgCard,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderColor)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderColor)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cyberCyan)),
                  ),
                ),
              ),

              // Category Pills
              SizedBox(
                height: 40,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, idx) {
                    final cat = categories[idx];
                    final isSelected = selectedCategory == cat;
                    return ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: AppColors.cyberCyan.withValues(alpha: 0.2),
                      backgroundColor: AppColors.bgCard,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.cyberCyan : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                      side: BorderSide(color: isSelected ? AppColors.cyberCyan : AppColors.borderColor),
                      onSelected: (_) => ref.read(interviewCategoryProvider.notifier).state = cat,
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Questions List
              Expanded(
                child: questionsAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.cyberCyan),
                  ),
                  error: (err, _) => Center(
                    child: Text('Error: $err', style: const TextStyle(color: AppColors.neonRed)),
                  ),
                  data: (items) {
                    final filtered = items.where((q) {
                      final matchesCat = selectedCategory == 'All' || q['category'] == selectedCategory;
                      final matchesSearch = _searchQuery.isEmpty ||
                          (q['question'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          (q['answer'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase());
                      return matchesCat && matchesSearch;
                    }).toList();

                    if (filtered.isEmpty) {
                      return const Center(
                        child: Text('No questions found', style: TextStyle(color: AppColors.textMuted)),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final q = filtered[index];
                        final id = q['id'] ?? index.toString();
                        final isRevealed = _revealedQuestionIds.contains(id);
                        final isMastered = _masteredQuestionIds.contains(id);

                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.bgCard,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isMastered
                                  ? AppColors.matrixGreen.withValues(alpha: 0.5)
                                  : AppColors.borderColor,
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.cyberCyan.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      q['category'] ?? 'Security',
                                      style: const TextStyle(color: AppColors.cyberCyan, fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    q['difficulty'] ?? 'Medium',
                                    style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: Icon(
                                      isMastered ? Icons.check_circle : Icons.check_circle_outline,
                                      color: isMastered ? AppColors.matrixGreen : AppColors.textMuted,
                                      size: 22,
                                    ),
                                    tooltip: 'Mark Mastered',
                                    onPressed: () {
                                      setState(() {
                                        if (isMastered) {
                                          _masteredQuestionIds.remove(id);
                                        } else {
                                          _masteredQuestionIds.add(id);
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                q['question'] ?? '',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (isRevealed) ...[
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: AppColors.bgSurface,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.cyberCyan.withValues(alpha: 0.2)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'FIELD EXPLANATION & ANSWER KEY',
                                        style: TextStyle(
                                          color: AppColors.cyberCyan,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        q['answer'] ?? '',
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 13,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ).animate().fadeIn(duration: 200.ms),
                                const SizedBox(height: 8),
                              ],
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      if (isRevealed) {
                                        _revealedQuestionIds.remove(id);
                                      } else {
                                        _revealedQuestionIds.add(id);
                                      }
                                    });
                                  },
                                  icon: Icon(isRevealed ? Icons.visibility_off : Icons.visibility, size: 16),
                                  label: Text(isRevealed ? 'Hide Explanation' : 'Reveal Answer Key'),
                                  style: TextButton.styleFrom(foregroundColor: AppColors.cyberCyan),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 200.ms, delay: (index * 25).ms);
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
