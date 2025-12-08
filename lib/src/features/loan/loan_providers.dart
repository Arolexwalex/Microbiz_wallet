// lib/src/features/loan/loan_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../data/dio_provider.dart';

class LoanRepository {
  final Dio _dio;
  LoanRepository(this._dio);

  Future<void> submitApplication({
    required String businessName,
    required int amount,
    required String purpose,
    required String lender,
    required int userId,
    required String phone,
    required String email,
  }) async {
    final payload = {
      "business_name": businessName,
      "amount": amount,
      "purpose": purpose,
      "lender": lender,
      "source": "MicroBiz Wallet",
      "status": "pending",
      "user_id": userId,
      "phone": phone,
      "email": email,
    };

    print("Sending to backend: $payload");

    try {
      // THIS IS THE FIX — REMOVE THE /api PREFIX HERE
      final response = await _dio.post('/loan-applications', data: payload);
      print("200 OK: ${response.data}");
    } on DioException catch (e) {
      final error = e.response?.data ?? e.message ?? e.message;
      print("ERROR: $error");
      throw Exception(error);
    }
  }
}

final loanRepositoryProvider = Provider((ref) => LoanRepository(ref.watch(dioProvider)));

// List of applications — also remove /api here
final loanApplicationsProvider = FutureProvider<List<dynamic>>((ref) async {
  final response = await ref.read(dioProvider).get('/loan-applications'); // ← NO /api
  return response.data as List;
});