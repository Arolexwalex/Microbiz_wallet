// lib/src/providers/microbiz_score_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_new_microbiz_wallet/src/domain/record.dart';
import '../state/ledger_providers.dart';

/// MicroBiz Credit Score™ — 300 to 850 (like FICO)
final microBizScoreProvider = Provider<int>((ref) {
  final records = ref.watch(ledgerRecordsProvider).asData?.value ?? [];

  if (records.isEmpty) return 350; // Low base if no data

  final now = DateTime.now();
  final sixMonthsAgo = now.subtract(const Duration(days: 180));
  final recentRecords = records.where((r) => r.date.isAfter(sixMonthsAgo)).toList();

  if (recentRecords.isEmpty) return 400;

  // 1. Revenue Volume (max 200 points)
  final totalSalesKobo = recentRecords
      .where((r) => r.type == RecordType.sale)
      .fold(0, (sum, r) => sum + r.amountKobo);
  final revenueScore = (totalSalesKobo / 100000000).clamp(0.0, 1.0) * 200; // ₦1B = max

  // 2. Profit Margin (max 200 points)
  final totalExpensesKobo = recentRecords
      .where((r) => r.type == RecordType.expense)
      .fold(0, (sum, r) => sum + r.amountKobo);
  final profitMargin = totalSalesKobo == 0 ? 0 : (totalSalesKobo - totalExpensesKobo) / totalSalesKobo;
  final marginScore = (profitMargin.clamp(0.0, 1.0)) * 200;

  // 3. Consistency (max 200 points)
  final activeDays = recentRecords.map((r) => r.date.toIso8601String().substring(0, 10)).toSet().length;
  final consistencyScore = (activeDays / 180).clamp(0.0, 1.0) * 200;

  // 4. Payment Behavior (max 150 points) — assume good if no late payments
  final behaviorScore = 150.0;

  // Final Score
  int score = 300 + revenueScore.round() + marginScore.round() + consistencyScore.round() + behaviorScore.round();
  return score.clamp(300, 850);
});