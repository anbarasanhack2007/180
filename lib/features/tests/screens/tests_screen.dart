import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/cyber_background.dart';
import '../../../services/supabase_service.dart';
import '../../../core/constants/app_routes.dart';

final testsListProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final data = await SupabaseService.tests
      .select()
      .order('week_number', nullsFirst: false);
  return List<Map<String, dynamic>>.from(data as List);
});

class TestsScreen extends ConsumerWidget {
  const TestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testsAsync = ref.watch(testsListProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CyberBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              floating: true,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: AppColors.textPrimary),
                onPressed: () => context.pop(),
              ),
              title: Text('TESTS & EXAMS',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary, letterSpacing: 1)),
              centerTitle: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),
                  testsAsync.when(
                    data: (tests) {
                      if (tests.isEmpty) {
                        return _empty(context);
                      }
                      final weekly = tests
                          .where((t) => t['test_type'] == 'weekly')
                          .toList();
                      final monthly = tests
                          .where((t) => t['test_type'] == 'monthly')
                          .toList();
                      final finals = tests
                          .where((t) => t['test_type'] == 'final')
                          .toList();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (finals.isNotEmpty) ...[
                            _section(context, '🎯 FINAL EXAM', finals,
                                AppColors.cyberRed),
                            const SizedBox(height: 16),
                          ],
                          if (monthly.isNotEmpty) ...[
                            _section(context, '📋 MONTHLY EXAMS', monthly,
                                AppColors.cyberOrange),
                            const SizedBox(height: 16),
                          ],
                          if (weekly.isNotEmpty)
                            _section(context, '📝 WEEKLY TESTS', weekly,
                                AppColors.cyberBlue),
                        ],
                      );
                    },
                    loading: () => const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.cyberCyan)),
                    error: (e, _) => _error(context, ref),
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

  Widget _section(BuildContext context, String title,
      List<Map<String, dynamic>> items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: color, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        ...items.map((t) => GestureDetector(
              onTap: () => context.push('${AppRoutes.tests}/${t['id']}'),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(Icons.quiz_outlined, color: color, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t['title'] as String? ?? '',
                              style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          Text(t['description'] as String? ?? '',
                              style: const TextStyle(
                                  color: AppColors.textHint, fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: AppColors.textHint),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _empty(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(children: [
            const Icon(Icons.quiz_outlined,
                color: AppColors.textHint, size: 56),
            const SizedBox(height: 16),
            Text('Tests not loaded yet.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary)),
            Text('Run seed.sql to populate tests.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.textHint)),
          ]),
        ),
      );

  Widget _error(BuildContext context, WidgetRef ref) => Center(
        child: Column(children: [
          const Icon(Icons.error_outline, color: AppColors.cyberRed),
          const SizedBox(height: 8),
          const Text('Failed to load tests',
              style: TextStyle(color: AppColors.textSecondary)),
          TextButton(
              onPressed: () => ref.refresh(testsListProvider),
              child: const Text('Retry')),
        ]),
      );
}
