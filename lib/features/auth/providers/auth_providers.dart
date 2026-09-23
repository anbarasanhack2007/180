import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../domain/entities/user_profile.dart';

export '../../../data/repositories/auth_repository.dart';
export '../../../domain/entities/user_profile.dart';

// Auth state provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});

// Current user profile provider
final currentProfileProvider =
    AsyncNotifierProvider<CurrentProfileNotifier, UserProfile?>(
        CurrentProfileNotifier.new);

class CurrentProfileNotifier extends AsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() async {
    // Watch auth state changes
    ref.watch(authStateProvider);
    final repo = ref.read(authRepositoryProvider);
    if (!repo.isSignedIn) return null;
    return await repo.getCurrentProfile();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    state = AsyncData(await repo.getCurrentProfile());
  }

  Future<void> updateProfile(UserProfile profile) async {
    final repo = ref.read(authRepositoryProvider);
    final updated = await repo.updateProfile(profile);
    state = AsyncData(updated);
  }

  void clear() {
    state = const AsyncData(null);
  }
}

// Auth actions provider
final authActionsProvider = Provider<AuthActions>((ref) {
  return AuthActions(ref);
});

class AuthActions {
  AuthActions(this._ref);
  final Ref _ref;

  AuthRepository get _repo => _ref.read(authRepositoryProvider);

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    await _repo.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );
    await _ref.read(currentProfileProvider.notifier).refresh();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _repo.signIn(email: email, password: password);
    await _ref.read(currentProfileProvider.notifier).refresh();
  }

  Future<void> signOut() async {
    await _repo.signOut();
    _ref.read(currentProfileProvider.notifier).clear();
  }

  Future<void> resetPassword(String email) async {
    await _repo.resetPassword(email);
  }
}

// Convenience selector for checking admin role
final isAdminProvider = Provider<bool>((ref) {
  final profile = ref.watch(currentProfileProvider).valueOrNull;
  return profile?.isAdmin ?? false;
});

// Onboarding needed check
final needsOnboardingProvider = Provider<bool>((ref) {
  final profile = ref.watch(currentProfileProvider).valueOrNull;
  if (profile == null) return false;
  return profile.college == null || profile.college!.isEmpty;
});
