import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'invoice_model.freezed.dart';
part 'invoice_model.g.dart';

@freezed
abstract class Invoice with _$Invoice {
  const factory Invoice({
    int? id,
    int? customerId,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required String invoiceNumber,
    required DateTime dateIssued,
    required DateTime dueDate,
    required List<InvoiceItem> items,
    required double totalAmount,
    @Default('Pending') String status, // e.g., Pending, Paid, Overdue
  }) = _Invoice; // This line is correct, the error is likely in the generated code or how it's being used.
  
  factory Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);
}

@freezed
abstract class InvoiceItem with _$InvoiceItem {
  const factory InvoiceItem({
    required String description,
    required int quantity,
    required int unitPriceKobo,
  }) = _InvoiceItem;

  factory InvoiceItem.fromJson(Map<String, dynamic> json) => _$InvoiceItemFromJson(json);
}

extension InvoiceSupabaseX on Invoice {
  /// Helper method to format data for Supabase insertion, excluding fields
  /// that the database generates automatically (like id and totalAmount).
  Map<String, dynamic> toSupabaseJson() => {
        'customer_name': customerName,
        'customer_email': customerEmail,
        'customer_phone': customerPhone,
        'invoice_number': invoiceNumber,
        'date_issued': dateIssued.toIso8601String(),
        'due_date': dueDate.toIso8601String(),
        'status': status,
      };
}