// lib/src/data/dio_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // Import for kDebugMode
import '../state/auth_providers.dart';

final dioProvider = Provider<Dio>((ref) {
  // Use localhost for debug builds, and the production URL for release builds.
  final baseUrl = kDebugMode
      ? 'http://localhost:3000/api'
      : 'https://microbiz-wallet-backend.onrender.com/api';

  final dio = Dio(BaseOptions( 
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 30), 
    receiveTimeout: const Duration(seconds: 30), // Increase for long-running queries
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