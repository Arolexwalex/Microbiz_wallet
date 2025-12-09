// lib/src/data/dio_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../state/auth_providers.dart';

final dioProvider = Provider<Dio>((ref) {
  // This is your live backend URL — never changes
  final dio = Dio(BaseOptions(
    baseUrl: 'https://microbiz-wallet-backend.onrender.com/api',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  // Automatically adds your login token to every request
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      final token = ref.read(authStateProvider).token;
      if (token != null && token.isNotEmpty) {
        options.headers['x-access-token'] = token;
      }
      handler.next(options);
    },
  ));

  return dio;
});