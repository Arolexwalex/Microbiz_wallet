// lib/src/data/dio_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../state/auth_providers.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:3000/api', // Keep /api here
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  ));

  // THIS IS THE KEY — ADD TOKEN TO EVERY REQUEST
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      final token = ref.read(authStateProvider).token;
      if (token != null && token.isNotEmpty == true) {
        options.headers['x-access-token'] = token;
        print('Token attached: ${token.substring(0, 20)}...');
      } else {
        print('No token found!');
      }
      handler.next(options);
    },
    onError: (error, handler) {
      if (error.response?.statusCode == 401) {
        print('401 — Logging out...');
        ref.read(authStateProvider.notifier).logout();
      }
      handler.next(error);
    },
  ));

  return dio;
});