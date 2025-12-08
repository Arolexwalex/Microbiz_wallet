// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoanApplication _$LoanApplicationFromJson(Map<String, dynamic> json) =>
    _LoanApplication(
      id: json['id'] as String,
      businessName: json['businessName'] as String,
      amountRequested: (json['amountRequested'] as num).toDouble(),
      purpose: json['purpose'] as String,
      status: json['status'] as String,
      appliedAt: DateTime.parse(json['appliedAt'] as String),
      lenderName: json['lenderName'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      approvedAt: json['approvedAt'] == null
          ? null
          : DateTime.parse(json['approvedAt'] as String),
      disbursedAt: json['disbursedAt'] == null
          ? null
          : DateTime.parse(json['disbursedAt'] as String),
    );

Map<String, dynamic> _$LoanApplicationToJson(_LoanApplication instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessName': instance.businessName,
      'amountRequested': instance.amountRequested,
      'purpose': instance.purpose,
      'status': instance.status,
      'appliedAt': instance.appliedAt.toIso8601String(),
      'lenderName': instance.lenderName,
      'rejectionReason': instance.rejectionReason,
      'approvedAt': instance.approvedAt?.toIso8601String(),
      'disbursedAt': instance.disbursedAt?.toIso8601String(),
    };
