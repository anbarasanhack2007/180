import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../../services/supabase_service.dart';
import '../../../core/constants/app_routes.dart';

final testDetailFutureProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, id) async {
  final data = await SupabaseService.tests
      .select('*, questions(*)')
      .eq('id', id)
      .maybeSingle();
  return data;
});

class TestDetailScreen extends ConsumerWidget {
  final String testId;
  const TestDetailScreen({super.key, required this.testId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(testDetailFutureProvider(testId));
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('TEST DETAILS'),
        centerTitle: true,
      ),
      body: CyberBackground(
        child: async.when(
          data: (test) {
            if (test == null) return const Center(child: Text('Test not found', style: TextStyle(color: AppColors.textSecondary)));
            final questions = test['questions'] as List<dynamic>? ?? [];
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(test['title'] as String? ?? '', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text(test['description'] as String? ?? '', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _infoChip('${questions.length} Questions', AppColors.cyberCyan),
                      const SizedBox(width: 8),
                      _infoChip(test['test_type'] as String? ?? '', AppColors.cyberPurple),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('${AppRoutes.tests}/$testId/attempt'),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('START TEST'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.cyberCyan, foregroundColor: AppColors.bgPrimary),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.cyberCyan)),
          error: (e, _) => Center(child: Text('Error loading test', style: const TextStyle(color: AppColors.cyberRed))),
        ),
      ),
    );
  }

  Widget _infoChip(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
    child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
  );
}
