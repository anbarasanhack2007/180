import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../auth/providers/auth_providers.dart';

class ResumeScreen extends ConsumerStatefulWidget {
  const ResumeScreen({super.key});

  @override
  ConsumerState<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends ConsumerState<ResumeScreen> {
  final _nameController = TextEditingController(text: 'Anbarasan M');
  final _emailController = TextEditingController(text: 'anbarasan.cyber@example.com');
  final _phoneController = TextEditingController(text: '+91 98765 43210');
  final _githubController = TextEditingController(text: 'https://github.com/anbarasan-sec');
  final _summaryController = TextEditingController(
    text: 'Dedicated 2nd-year B.Tech Cybersecurity student with intensive hands-on experience in network packet analysis, vulnerability assessment, SIEM log monitoring, and web application penetration testing. Proven ability to build automated security tooling in Python and dissect complex threat telemetry.',
  );
  final _skillsController = TextEditingController(
    text: 'Wireshark, Nmap, Burp Suite, Metasploit, Splunk, Linux / Bash scripting, Python (Scapy, Sockets), OWASP Top 10, TCP/IP & Network Architecture, Snort IDS.',
  );
  final _educationController = TextEditingController(
    text: 'B.Tech in Cybersecurity, Expected Graduation: 2028\\nRelevant Coursework: Computer Networks, Cryptography, Operating Systems, Ethical Hacking.',
  );

  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(currentProfileProvider).valueOrNull;
    if (profile != null && profile.fullName.isNotEmpty) {
      _nameController.text = profile.fullName;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _githubController.dispose();
    _summaryController.dispose();
    _skillsController.dispose();
    _educationController.dispose();
    super.dispose();
  }

  Future<void> _exportPdf() async {
    setState(() => _isExporting = true);
    try {
      final doc = pw.Document();

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Text(
                  _nameController.text,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blueGrey900,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  '${_emailController.text} | ${_phoneController.text} | ${_githubController.text}',
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                ),
                pw.SizedBox(height: 12),
                pw.Divider(color: PdfColors.grey400, thickness: 1),
                pw.SizedBox(height: 10),

                // Professional Summary
                pw.Text('PROFESSIONAL SUMMARY', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800)),
                pw.SizedBox(height: 4),
                pw.Text(_summaryController.text, style: const pw.TextStyle(fontSize: 10, color: PdfColors.black, lineSpacing: 1.3)),
                pw.SizedBox(height: 14),

                // Technical Arsenal
                pw.Text('TECHNICAL ARSENAL & SKILLS', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800)),
                pw.SizedBox(height: 4),
                pw.Text(_skillsController.text, style: const pw.TextStyle(fontSize: 10, color: PdfColors.black, lineSpacing: 1.3)),
                pw.SizedBox(height: 14),

                // Capstone Projects
                pw.Text('CYBERSECURITY CAPSTONE PROJECTS', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800)),
                pw.SizedBox(height: 6),

                pw.Text('1. Network Packet Sniffer & Protocol Analyzer (Python, Scapy, Raw Sockets)', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                pw.Bullet(text: 'Developed raw-socket packet sniffer capturing TCP, UDP, ICMP, DNS payloads with automated anomaly detection.', style: const pw.TextStyle(fontSize: 9)),
                pw.Bullet(text: 'Built export pipeline generating PCAP files for Wireshark inspection.', style: const pw.TextStyle(fontSize: 9)),
                pw.SizedBox(height: 6),

                pw.Text('2. Automated Port Scanner & Service Enumeration (Python, Nmap)', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                pw.Bullet(text: 'Created multi-threaded TCP SYN port scanner scanning 1000 ports in under 3 seconds with CVE correlation.', style: const pw.TextStyle(fontSize: 9)),
                pw.SizedBox(height: 6),

                pw.Text('3. SOC Log Analysis & SIEM Detection Pipeline (Splunk, Zeek)', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                pw.Bullet(text: 'Formulated custom SPL detection rules identifying SSH brute-force campaigns and data exfiltration patterns.', style: const pw.TextStyle(fontSize: 9)),
                pw.SizedBox(height: 14),

                // Education
                pw.Text('EDUCATION & CREDENTIALS', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800)),
                pw.SizedBox(height: 4),
                pw.Text(_educationController.text, style: const pw.TextStyle(fontSize: 10, color: PdfColors.black, lineSpacing: 1.3)),
                pw.SizedBox(height: 6),
                pw.Bullet(text: 'CyberSprint 180: Advanced Full-Stack Cybersecurity Mastery Curriculum', style: const pw.TextStyle(fontSize: 9)),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
        name: 'Cybersecurity_Resume_${_nameController.text.replaceAll(' ', '_')}.pdf',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating PDF: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CyberBackground(
        child: SafeArea(
          child: Column(
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
                            'CAREER WEAPON',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.cyberCyan,
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            'Resume Generator',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _isExporting ? null : _exportPdf,
                      icon: _isExporting
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.bgPrimary),
                            )
                          : const Icon(Icons.print, size: 16),
                      label: const Text('Export PDF', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cyberCyan,
                        foregroundColor: AppColors.bgPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),

              // Form fields
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('CONTACT & IDENTIFICATION'),
                      _buildTextField(_nameController, 'Full Name', Icons.person),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _buildTextField(_emailController, 'Email', Icons.email)),
                          const SizedBox(width: 10),
                          Expanded(child: _buildTextField(_phoneController, 'Phone', Icons.phone)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(_githubController, 'GitHub / Portfolio URL', Icons.link),

                      const SizedBox(height: 20),
                      _buildSectionHeader('PROFESSIONAL SUMMARY'),
                      _buildTextArea(_summaryController, 'Summary Statement', 4),

                      const SizedBox(height: 20),
                      _buildSectionHeader('TECHNICAL ARSENAL'),
                      _buildTextArea(_skillsController, 'Tools, Protocols & Frameworks', 3),

                      const SizedBox(height: 20),
                      _buildSectionHeader('EDUCATION & ACADEMICS'),
                      _buildTextArea(_educationController, 'Degree, College & Graduation', 3),

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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.cyberCyan,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        prefixIcon: Icon(icon, color: AppColors.cyberCyan, size: 18),
        filled: true,
        fillColor: AppColors.bgCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderColor)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.cyberCyan)),
      ),
    );
  }

  Widget _buildTextArea(TextEditingController controller, String label, int minLines) {
    return TextField(
      controller: controller,
      maxLines: null,
      minLines: minLines,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, height: 1.4),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        filled: true,
        fillColor: AppColors.bgCard,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderColor)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.cyberCyan)),
      ),
    );
  }
}
