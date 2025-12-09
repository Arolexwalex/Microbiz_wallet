// lib/src/data/dio_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      // Get the token from the current Supabase session
      final accessToken = Supabase.instance.client.auth.currentSession?.accessToken;
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
      handler.next(options);
    },
  ));

  return dio;
});