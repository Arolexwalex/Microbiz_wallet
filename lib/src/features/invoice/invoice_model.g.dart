// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Invoice _$InvoiceFromJson(Map<String, dynamic> json) => _Invoice(
  id: json['id'] as String,
  customerId: (json['customerId'] as num?)?.toInt(),
  customerName: json['customerName'] as String,
  customerEmail: json['customerEmail'] as String,
  customerPhone: json['customerPhone'] as String,
  invoiceNumber: json['invoiceNumber'] as String,
  dateIssued: DateTime.parse(json['dateIssued'] as String),
  dueDate: DateTime.parse(json['dueDate'] as String),
  items: (json['items'] as List<dynamic>)
      .map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalAmount: (json['totalAmount'] as num).toDouble(),
  status: json['status'] as String? ?? 'Pending',
);

Map<String, dynamic> _$InvoiceToJson(_Invoice instance) => <String, dynamic>{
  'id': instance.id,
  'customerId': instance.customerId,
  'customerName': instance.customerName,
  'customerEmail': instance.customerEmail,
  'customerPhone': instance.customerPhone,
  'invoiceNumber': instance.invoiceNumber,
  'dateIssued': instance.dateIssued.toIso8601String(),
  'dueDate': instance.dueDate.toIso8601String(),
  'items': instance.items,
  'totalAmount': instance.totalAmount,
  'status': instance.status,
};

_InvoiceItem _$InvoiceItemFromJson(Map<String, dynamic> json) => _InvoiceItem(
  description: json['description'] as String,
  quantity: (json['quantity'] as num).toInt(),
  unitPrice: (json['unitPrice'] as num).toDouble(),
);

Map<String, dynamic> _$InvoiceItemToJson(_InvoiceItem instance) =>
    <String, dynamic>{
      'description': instance.description,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
    };
