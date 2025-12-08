import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_new_microbiz_wallet/src/domain/record.dart';
import 'dio_provider.dart';

class LedgerRepository {
  final Dio _dio;

  LedgerRepository(this._dio);

  Future<List<LedgerRecord>> getAllRecords() async {
   try {
    final response = await _dio.get('/ledger');
    return (response.data as List)
        .map((json) => LedgerRecord.fromJson(json))
        .toList();
  } on DioException catch (e) {
    print('Ledger fetch error: ${e.response?.statusCode} ${e.message}');
    rethrow;
  }
  }

  Future<void> add(LedgerRecord record) async {
    try {
      await _dio.post(
        '/ledger', // REMOVED /api prefix
        data: {
          'title': record.title,
          'amount': record.amountKobo / 100.0, // Send in Naira
          'date': record.date.toIso8601String(),
          'category': record.category,
          'note': record.note,
          'type': record.type == RecordType.sale ? 'sale' : 'expense',
        },
      );
    } on DioException catch (e) {
      throw Exception('Failed to save: ${e.response?.statusCode}');
    }
  }
}