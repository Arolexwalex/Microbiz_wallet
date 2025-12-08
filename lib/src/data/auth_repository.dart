import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dio_provider.dart';

class AuthRepository {
  static const String _tokenKey = 'jwt_token';
  static const String _userIdKey = 'user_id';
  static const String _onboardingCompletedKey = 'onboarding_completed';
  final Ref _ref;
  AuthRepository(this._ref);

  Dio get _dio => _ref.read(dioProvider);

  /// Checks if the backend server is reachable and responding correctly.
  Future<bool> checkBackendStatus() async {
    try {
      // Use the production URL but remove the '/api' suffix for the root health check.
      final baseUrl = _ref.read(dioProvider).options.baseUrl;
      final rootUrl = baseUrl.replaceAll('/api', '');

      final healthCheckDio = Dio(BaseOptions(baseUrl: rootUrl));
      final response = await healthCheckDio.get('/');
      if (response.statusCode == 200 && response.data['status'] == 'ok') {
        print('✅ Backend connection successful: ${response.data['message']}');
        return true;
      }
    } on DioException catch (e) {
      print('❌ Backend connection failed: ${e.message}');
    }
    return false;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  Future<bool> get isLoggedIn async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) != null;
  }

  Future<bool> get isOnboardingCompleted async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, completed);
  }

  Future<Map<String, dynamic>> signUp({required String username, required String email, required String password}) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'username': username,
        'email': email,
        'password': password,
      });
      return {'success': true, 'message': response.data['message']};
    } on DioException catch (e) {
      return {'success': false, 'message': e.response?.data['message'] ?? 'Sign up failed'};
    }
  }

  Future<Map<String, dynamic>> login({required String username, required String password}) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'username': username,
        'password': password,
      });

      final responseData = response.data as Map<String, dynamic>;
      final String? token = responseData['token'] as String?;
      final int? userId = responseData['userId'] as int?;

      if (token != null && userId != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);
        await prefs.setInt(_userIdKey, userId);
      }
      return {'success': true, ...responseData};
    } on DioException catch (e) {
      return {'success': false, 'message': e.response?.data['message'] ?? 'Login failed'};
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
  }
}
