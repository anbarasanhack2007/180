import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/cyber_background.dart';

class LabsScreen extends ConsumerWidget {
  const LabsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CyberBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              floating: true,
              leading: Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu, color: AppColors.textPrimary),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                ),
              ),
              title: Text(
                'LABS & RESOURCES',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      letterSpacing: 1,
                    ),
              ),
              centerTitle: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),
                  _sectionHeader(context, '🔴 YOUTUBE CHANNELS'),
                  const SizedBox(height: 8),
                  _labCard(
                    context,
                    title: 'Professor Messer',
                    description: 'CompTIA Security+, A+, Network+ study guides and videos.',
                    platform: 'YouTube',
                    icon: Icons.play_circle_filled,
                    color: const Color(0xFFFF0000),
                    url: AppConstants.ytProfessorMesser,
                  ),
                  _labCard(
                    context,
                    title: 'freeCodeCamp',
                    description: 'Full cybersecurity courses and ethical hacking tutorials.',
                    platform: 'YouTube',
                    icon: Icons.play_circle_filled,
                    color: const Color(0xFFFF0000),
                    url: AppConstants.ytFreeCodeCamp,
                  ),
                  _labCard(
                    context,
                    title: 'Corey Schafer',
                    description: 'Python programming for beginners and intermediate learners.',
                    platform: 'YouTube',
                    icon: Icons.play_circle_filled,
                    color: const Color(0xFFFF0000),
                    url: AppConstants.ytCoreySchafer,
                  ),
                  _labCard(
                    context,
                    title: 'PortSwigger Official',
                    description: 'Web security tutorials, Burp Suite guides.',
                    platform: 'YouTube',
                    icon: Icons.play_circle_filled,
                    color: const Color(0xFFFF0000),
                    url: AppConstants.ytPortSwigger,
                  ),
                  _labCard(
                    context,
                    title: 'John Hammond',
                    description: 'CTF walkthroughs, cybersecurity challenges and hacking videos.',
                    platform: 'YouTube',
                    icon: Icons.play_circle_filled,
                    color: const Color(0xFFFF0000),
                    url: AppConstants.ytJohnHammond,
                  ),
                  _labCard(
                    context,
                    title: 'The Cyber Mentor (TCM)',
                    description: 'Ethical hacking, pentesting, practical cybersecurity.',
                    platform: 'YouTube',
                    icon: Icons.play_circle_filled,
                    color: const Color(0xFFFF0000),
                    url: AppConstants.ytTCM,
                  ),
                  const SizedBox(height: 16),
                  _sectionHeader(context, '🟢 TRYHACKME PATHS'),
                  const SizedBox(height: 8),
                  _labCard(
                    context,
                    title: 'Pre-Security Path',
                    description: 'Start your cybersecurity journey. Learn the basics.',
                    platform: 'TryHackMe',
                    icon: Icons.science_outlined,
                    color: AppColors.cyberGreen,
                    url: AppConstants.thmPreSecurity,
                  ),
                  _labCard(
                    context,
                    title: 'Cybersecurity 101',
                    description: 'Core cybersecurity concepts for beginners.',
                    platform: 'TryHackMe',
                    icon: Icons.science_outlined,
                    color: AppColors.cyberGreen,
                    url: AppConstants.thmCyberSecurity101,
                  ),
                  _labCard(
                    context,
                    title: 'Jr Penetration Tester',
                    description: 'Learn ethical hacking and penetration testing fundamentals.',
                    platform: 'TryHackMe',
                    icon: Icons.science_outlined,
                    color: AppColors.cyberGreen,
                    url: AppConstants.thmJrPenTester,
                  ),
                  _labCard(
                    context,
                    title: 'SOC Level 1',
                    description: 'Blue team fundamentals — SOC analyst skills.',
                    platform: 'TryHackMe',
                    icon: Icons.science_outlined,
                    color: AppColors.cyberGreen,
                    url: AppConstants.thmSocLevel1,
                  ),
                  const SizedBox(height: 16),
                  _sectionHeader(context, '🟠 PORTSWIGGER WEB SECURITY'),
                  const SizedBox(height: 8),
                  _labCard(
                    context,
                    title: 'Web Security Academy',
                    description: 'Free web application security training with hands-on labs.',
                    platform: 'PortSwigger',
                    icon: Icons.bug_report_outlined,
                    color: AppColors.cyberOrange,
                    url: AppConstants.portSwiggerWebSecurity,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.cyberOrange.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.cyberOrange.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber,
                            color: AppColors.cyberOrange, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            AppConstants.educationDisclaimer,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.cyberOrange),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.5,
          ),
    );
  }

  Widget _labCard(
    BuildContext context, {
    required String title,
    required String description,
    required String platform,
    required IconData icon,
    required Color color,
    required String url,
  }) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.open_in_new, color: AppColors.textHint, size: 16),
          ],
        ),
      ),
    );
  }
}
