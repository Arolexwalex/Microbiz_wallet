import 'dart:convert';

enum RecordType { sale, expense }

class LedgerRecord {
  final String id;
  final DateTime date;
  final String category;
  final int amountKobo;
  final String title;
  final String note;
  final RecordType type;

  LedgerRecord({
    required this.id,
    required this.date,
    required this.category,
    required this.amountKobo,
    required this.title,
    required this.note,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amountKobo': amountKobo,
      'date': date.toIso8601String(),
      'category': category,
      'note': note,
      'type': type == RecordType.sale ? 'sale' : 'expense',
    };
  }

  // FIXED: Return Map, NOT String
  Map<String, dynamic> toJson() => toMap();

  factory LedgerRecord.fromJson(Map<String, dynamic> json) {
    return LedgerRecord(
      id: json['id'].toString(),
      title: json['description'] ?? '', // Match 'description' column from Supabase
      amountKobo: (json['amount_kobo'] is num) // Match 'amount_kobo' column from Supabase
          ? (json['amount_kobo'] as num).toInt()
          : int.tryParse(json['amount_kobo'].toString()) ?? 0,
      date: DateTime.parse(json['date']),
      category: json['category'] ?? 'General',
      note: json['note'] ?? '',
      type: json['type'] == 'sale' ? RecordType.sale : RecordType.expense,
    );
  }
}