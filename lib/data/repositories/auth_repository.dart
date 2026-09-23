import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/supabase_service.dart';
import '../models/profile_model.dart';
import '../../domain/entities/user_profile.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

abstract class AuthRepository {
  Future<UserProfile?> signUp({
    required String email,
    required String password,
    required String fullName,
  });
  Future<UserProfile?> signIn({
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<UserProfile?> getCurrentProfile();
  Future<UserProfile> updateProfile(UserProfile profile);
  Stream<AuthState> get authStateChanges;
  bool get isSignedIn;
  String? get currentUserId;
}

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<UserProfile?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final response = await SupabaseService.signUp(
      email: email,
      password: password,
    );
    if (response.user == null) return null;

    // Profile is created by database trigger
    // Wait a moment for the trigger to execute
    await Future.delayed(const Duration(milliseconds: 500));

    // Update the full_name
    await SupabaseService.profiles.update(
        {'full_name': fullName, 'email': email}).eq('id', response.user!.id);

    return await getCurrentProfile();
  }

  @override
  Future<UserProfile?> signIn({
    required String email,
    required String password,
  }) async {
    final response = await SupabaseService.signIn(
      email: email,
      password: password,
    );
    if (response.user == null) return null;
    return await getCurrentProfile();
  }

  @override
  Future<void> signOut() async {
    await SupabaseService.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    await SupabaseService.resetPassword(email);
  }

  @override
  Future<UserProfile?> getCurrentProfile() async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) return null;

    final data =
        await SupabaseService.profiles.select().eq('id', userId).maybeSingle();

    if (data == null) return null;
    return ProfileModel.fromJson(data);
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    final model = profile as ProfileModel? ??
        ProfileModel(
          id: profile.id,
          fullName: profile.fullName,
          email: profile.email,
          college: profile.college,
          degree: profile.degree,
          studyYear: profile.studyYear,
          dailyGoalMinutes: profile.dailyGoalMinutes,
          avatarUrl: profile.avatarUrl,
          githubUrl: profile.githubUrl,
          linkedinUrl: profile.linkedinUrl,
          portfolioUrl: profile.portfolioUrl,
          role: profile.role,
          cybersecurityLevel: profile.cybersecurityLevel,
          createdAt: profile.createdAt,
          updatedAt: profile.updatedAt,
        );

    final updateData = model.toJson()
      ..remove('id')
      ..['updated_at'] = DateTime.now().toIso8601String();

    final data = await SupabaseService.profiles
        .update(updateData)
        .eq('id', profile.id)
        .select()
        .single();

    return ProfileModel.fromJson(data);
  }

  @override
  Stream<AuthState> get authStateChanges => SupabaseService.authStateChanges;

  @override
  bool get isSignedIn => SupabaseService.isSignedIn;

  @override
  String? get currentUserId => SupabaseService.currentUserId;
}
