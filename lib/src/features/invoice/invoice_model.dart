import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'invoice_model.freezed.dart';
part 'invoice_model.g.dart';

@freezed
abstract class Invoice with _$Invoice {
  const factory Invoice({
    required String id,
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
    required double unitPrice,
  }) = _InvoiceItem;

  factory InvoiceItem.fromJson(Map<String, dynamic> json) => _$InvoiceItemFromJson(json);
}