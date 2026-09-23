import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/supabase_service.dart';

final allProjectsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final data = await SupabaseService.projects
        .select('*, project_tasks(*)')
        .order('project_number');
    return List<Map<String, dynamic>>.from(data as List);
  } catch (_) {
    return [];
  }
});

final userProjectProgressProvider =
    FutureProvider.family<Map<String, dynamic>?, String>(
        (ref, projectId) async {
  final userId = SupabaseService.currentUserId;
  if (userId == null) return null;
  try {
    final data = await SupabaseService.userProjectProgress
        .select()
        .eq('user_id', userId)
        .eq('project_id', projectId)
        .maybeSingle();
    return data;
  } catch (_) {
    return null;
  }
});
