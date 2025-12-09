import 'package:new_new_microbiz_wallet/src/domain/record.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LedgerRepository {
  final SupabaseClient _supabase;

  LedgerRepository(this._supabase);

  /// Fetches all ledger records for the currently authenticated user from Supabase.
  Future<List<LedgerRecord>> getAllRecords() async {
    try {
      // Select all records where the user_id matches the current user's id.
      // RLS on the backend provides the primary layer of security.
      final data = await _supabase
          .from('ledger')
          .select()
          .order('date', ascending: false); // Order by date, newest first

      // Convert the list of maps into a list of LedgerRecord objects.
      final records = data.map((item) => LedgerRecord.fromJson(item)).toList();
      return records;
    } catch (e) {
      // If there's an error, print it and rethrow it as an exception.
      print('Ledger fetch error: $e');
      throw Exception('Failed to fetch ledger records.');
    }
  }

  // You can add methods for creating, updating, and deleting records here later.
  /// Creates a new ledger record in Supabase.
  Future<void> createRecord(Map<String, dynamic> recordData) async {
    try {
      await _supabase.from('ledger').insert(recordData);
    } catch (e) {
      print('Ledger create error: $e');
      throw Exception('Failed to create ledger record.');
    }
  }
}
