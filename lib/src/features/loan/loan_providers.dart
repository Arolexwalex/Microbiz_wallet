import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_new_microbiz_wallet/src/domain/loan_model.dart'; // Correctly uses the freezed model
import 'package:new_new_microbiz_wallet/src/state/auth_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoanRepository {
  final SupabaseClient _supabase;

  LoanRepository(this._supabase);

  Future<void> submitApplication({
    required String businessName,
    required int amount,
    required String purpose,
    required String lender,
  }) async {
    try {
      // The user_id is handled automatically by Supabase policies
      await _supabase.from('loan_applications').insert({
        'business_name': businessName,
        'amount_requested': amount,
        'purpose': purpose,
        'lender_name': lender,
      });
    } catch (e) {
      print('Loan submission error: $e');
      throw Exception('Failed to submit loan application.');
    }
  }

  Future<List<LoanApplication>> getApplications() async {
    try {
      final data = await _supabase
          .from('loan_applications')
          .select()
          .order('created_at', ascending: false);
      return data.map((item) => LoanApplication.fromJson(item)).toList();
    } catch (e) {
      print('Loan fetch error: $e');
      throw Exception('Failed to fetch loan applications.');
    }
  }
}

final loanRepositoryProvider = Provider<LoanRepository>((ref) {
  return LoanRepository(ref.read(supabaseProvider));
});

final loanApplicationsProvider = FutureProvider.autoDispose<List<LoanApplication>>((ref) {
  return ref.watch(loanRepositoryProvider).getApplications();
});