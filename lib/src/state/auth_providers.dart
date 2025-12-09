import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider to safely access the Supabase client instance.
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// This provider exposes the Supabase auth state stream.
///
/// It will automatically notify listeners whenever the user signs in, signs out,
/// or the session is updated. This is the foundation of our reactive auth system.
final authStateChangesProvider = StreamProvider.autoDispose<AuthState>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
});

/// Provider for SharedPreferences instance.
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// Provider to check if onboarding has been completed.
final onboardingCompletedProvider = FutureProvider<bool>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  // Defaults to false if the key doesn't exist.
  return prefs.getBool('onboarding_completed') ?? false;
});