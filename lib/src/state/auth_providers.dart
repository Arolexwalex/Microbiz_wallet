import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:new_new_microbiz_wallet/src/data/dio_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/auth_repository.dart';
// Import AuthRepository

/// Custom exception for authentication failures
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class AuthState {
  final String? name;
  final String? email;
  final String? phone;
  final String? dob;
  final bool isAuthenticated;
  final String? token; // Added for JWT token
  final int? userId; // Added for userId

  AuthState({
    this.name,
    this.email,
    this.phone,
    this.dob,
    this.isAuthenticated = false,
    this.token,
    this.userId,
  });

  AuthState copyWith({
    String? name,
    String? email,
    String? phone,
    String? dob,
    bool? isAuthenticated,
    String? token,
    int? userId,
  }) {
    return AuthState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
      userId: userId ?? this.userId,
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref);
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>( (ref) {
  return AuthNotifier(ref, ref.read(authRepositoryProvider));
});

final onboardingCompletedProvider = FutureProvider.autoDispose<bool>((ref) async {
  return ref.watch(authRepositoryProvider).isOnboardingCompleted;
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final Ref _ref; // Add Ref here
  static const String _nameKey = 'user_name';
  static const String _emailKey = 'user_email';
  static const String _phoneKey = 'user_phone';
  static const String _dobKey = 'user_dob';

  AuthNotifier(this._ref, this._authRepository) : super(AuthState()) {
    // Temporarily add this line to check the connection on startup
    _authRepository.checkBackendStatus();
    _loadSavedState();
  }

  Future<void> markOnboardingCompleted() async {
    await _authRepository.setOnboardingCompleted(true);
    // Invalidate the provider to force a rebuild with the new state
    _ref.invalidate(onboardingCompletedProvider);
  }

  Future<void> _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    final isAuthenticated = await _authRepository.isLoggedIn;
    final token = await _authRepository.getToken();
    final userId = await _authRepository.getUserId(); // Get userId from repository
    
    // We only load basic user info if authenticated
    if (isAuthenticated) {
      state = state.copyWith(
        name: prefs.getString(_nameKey),
        email: prefs.getString(_emailKey),
        phone: prefs.getString(_phoneKey),
        dob: prefs.getString(_dobKey),
        isAuthenticated: true,
        token: token,
        userId: userId,
      );
    }
  }

  Future<void> _saveUserInfo({
    String? name,
    String? email,
    String? phone,
    String? dob,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (name != null) await prefs.setString(_nameKey, name);
    if (email != null) await prefs.setString(_emailKey, email);
    if (phone != null) await prefs.setString(_phoneKey, phone);
    if (dob != null) await prefs.setString(_dobKey, dob);
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    final result = await _authRepository.signUp(
      username: username,
      email: email,
      password: password,
    );

    if (!result['success']) {
      throw AuthException(result['message'] ?? 'Sign up failed');
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final result = await _authRepository.login(
      username: username,
      password: password,
    );

    if (!result['success']) {
      throw AuthException(result['message'] ?? 'Login failed');
    }

    final String token = result['token'];
    final int userId = result['userId'];
    final String? name = result['name'];
    final String? email = result['email'];
    final String? phone = result['phone'];
    final String? dob = result['dob'];

    // Save user info to SharedPreferences
    await _saveUserInfo(name: name, email: email, phone: phone, dob: dob);

    state = state.copyWith(
      isAuthenticated: true,
      token: token,
      userId: userId,
      name: name,
      email: email,
      phone: phone,
      dob: dob,
    );
  }

  Future<void> demoLogin() async {
    // --- ONLINE DEMO LOGIN ---
    // This method now performs a real login against the backend
    // using the predefined demo user credentials.
    await login(
      username: 'demo_user',
      password: 'password123',
    );
  }

  Future<void> logout() async {
    await _authRepository.logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_phoneKey);
    await prefs.remove(_dobKey);
    state = AuthState(); // Reset state to unauthenticated
  }

  Future<bool> isLoggedIn() async {
    return await _authRepository.isLoggedIn;
  }
}