// lib/src/domain/loan_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'loan_model.freezed.dart';
part 'loan_model.g.dart';

@freezed
abstract class LoanApplication with _$LoanApplication {
  const factory LoanApplication({
    required String id,
    required String businessName,
    required double amountRequested,
    required String purpose,
    required String status,
    required DateTime appliedAt,
    String? lenderName,
    String? rejectionReason,
    DateTime? approvedAt,
    DateTime? disbursedAt,
  }) = _LoanApplication;

  factory LoanApplication.fromJson(Map<String, dynamic> json) =>
      _$LoanApplicationFromJson(json);
}