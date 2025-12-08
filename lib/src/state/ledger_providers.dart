import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import '../data/ledger_repository.dart';
import '../domain/record.dart';
import 'auth_providers.dart'; // Import auth_providers
import '../data/dio_provider.dart'; // Import dioProvider

final ledgerRepositoryProvider = Provider<LedgerRepository>((ref) {
  return LedgerRepository(ref.watch(dioProvider));
});

final ledgerRecordsProvider = FutureProvider.autoDispose<List<LedgerRecord>>((ref) async {
  final authState = ref.watch(authStateProvider);
  if (!authState.isAuthenticated || authState.token == null) {
    return []; // Return empty list if not authenticated
  }
  return ref.read(ledgerRepositoryProvider).getAllRecords();
});

// Update todayTotalsProvider and businessHealthProvider to use ledgerRecordsProvider
final todayTotalsProvider = FutureProvider.autoDispose((ref) async {
  final records = await ref.watch(ledgerRecordsProvider.future);
  if (records.isEmpty) { // Handle case where no records or not authenticated
    return (sales: 0, expenses: 0);
  }
  final now = DateTime.now();
  int sales = 0, expenses = 0;
  for (final r in records) {
    final sameDay = r.date.year == now.year && r.date.month == now.month && r.date.day == now.day;
    if (!sameDay) continue;
    if (r.type == RecordType.sale) sales += r.amountKobo;
    else expenses += r.amountKobo;
  }
  return (sales: sales, expenses: expenses);
});

final businessHealthProvider = FutureProvider.autoDispose<({
  int totalSales,
  int totalExpenses,
  int totalProfit,
  double profitMargin,
  double cashFlow,
  double revenueGrowth,
  double businessHealthScore,
  int activeDays,
})>((ref) async {
  final records = await ref.watch(ledgerRecordsProvider.future);
  if (records.isEmpty) { // Handle case where no records or not authenticated
    return (
      totalSales: 0,
      totalExpenses: 0,
      totalProfit: 0,
      profitMargin: 0.0,
      cashFlow: 0.0,
      revenueGrowth: 0.0,
      businessHealthScore: 0.0,
      activeDays: 0,
    );
  }
  final now = DateTime.now();
  final since = now.subtract(const Duration(days: 30));
  final previousSince = since.subtract(const Duration(days: 30));
  int sales = 0, expenses = 0, activeDays = 0;
  int previousSales = 0;
  final Set<String> days = {};

  for (final r in records) {
    if (r.date.isAfter(since)) {
      if (r.type == RecordType.sale) sales += r.amountKobo;
      if (r.type == RecordType.expense) expenses += r.amountKobo;
      days.add(DateFormat('yyyy-MM-dd').format(r.date));
    } else if (r.date.isAfter(previousSince) && r.date.isBefore(since)) {
      if (r.type == RecordType.sale) previousSales += r.amountKobo;
    }
  }
  activeDays = days.length;

  final profit = (sales - expenses).clamp(0, sales);
  final profitMargin = sales == 0 ? 0.0 : ((sales - expenses) / sales.toDouble()).clamp(0.0, 1.0);

  final cashFlow = (profit / 100.0).clamp(0.0, 50000.0) / 50000.0; // Normalized

  final revenueGrowth = previousSales == 0 ? 0.0 : ((sales - previousSales) / previousSales.toDouble()).clamp(-1.0, 1.0);

  final businessHealthScore = (0.4 * profitMargin + 0.3 * cashFlow + 0.3 * (activeDays / 30.0)).clamp(0.0, 1.0);

  return (
    totalSales: sales,
    totalExpenses: expenses,
    totalProfit: profit,
    profitMargin: profitMargin,
    cashFlow: cashFlow * 50000.0, // Denormalized
    revenueGrowth: revenueGrowth,
    businessHealthScore: businessHealthScore,
    activeDays: activeDays,
  );
});