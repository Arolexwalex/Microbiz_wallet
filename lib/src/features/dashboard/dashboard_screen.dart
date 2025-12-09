// lib/src/features/dashboard/dashboard_screen.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:new_new_microbiz_wallet/src/domain/record.dart';
import '../../state/ledger_providers.dart';
import '../../theme/theme.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const _services = [
    {'icon': Icons.add_chart_rounded, 'label': 'Add Sales', 'route': '/add-sales'},
    {'icon': Icons.request_quote_rounded, 'label': 'Add Expense', 'route': '/add-expenses'},
    {'icon': Icons.receipt_long_rounded, 'label': 'Invoices', 'route': '/invoices'},
    {'icon': Icons.money_off_rounded, 'label': 'Debt Tracker', 'route': '/debts'},
    {'icon': Icons.account_balance_wallet_rounded, 'label': 'Budget', 'route': '/budget'},
    {'icon': Icons.history_rounded, 'label': 'Ledger', 'route': '/ledger'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(ledgerRecordsProvider);
          ref.invalidate(businessHealthProvider);
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: isWeb ? 64 : 20, vertical: 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildHeroProfitCard(context, ref),
                  const SizedBox(height: 32),
                  _buildQuickActions(context),
                  const SizedBox(height: 32),
                  _buildRecentTransactions(ref: ref, context: context),
                  const SizedBox(height: 32),
                  _buildProfitChart(context, ref),
                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ... (hero card and quick actions same as before)

  Widget _buildHeroProfitCard(BuildContext context, WidgetRef ref) {
    return ref.watch(businessHealthProvider).when(
      data: (health) {
        final format = NumberFormat.currency(locale: 'en_NG', symbol: '₦', decimalDigits: 0);
        final profit = health.totalProfit / 100;
        final isPositive = profit >= 0;

        return Card(
          elevation: 16,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                colors: isPositive
                    ? [const Color(0xFF00C853), const Color(0xFF00E676)]
                    : [const Color(0xFFE53935), const Color(0xFFFF5252F)],
              ),
            ),
            child: Column(
              children: [
                Text('30-Day Net Profit', style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 12),
                Text(format.format(profit.abs()),
                    style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                        color: Colors.white, size: 36),
                    const SizedBox(width: 12),
                    Text(isPositive ? 'Business is growing!' : 'Time to cut costs',
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => context.push('/business-health'),
                  icon: const Icon(Icons.insights_rounded),
                  label: const Text('View Full Report'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: isPositive ? Colors.green : Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Card(child: SizedBox(height: 200, child: Center(child: CircularProgressIndicator()))),
      error: (_, __) => Card(
        color: Colors.red.shade50,
        child: const SizedBox(height: 200, child: Center(child: Text('Failed to load profit', style: TextStyle(color: Colors.red)))),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _services.length,
          itemBuilder: (context, i) {
            final s = _services[i];
            return Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => context.push(s['route'] as String),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(s['icon'] as IconData, size: 40, color: AppColors.primary),
                    const SizedBox(height: 12),
                    Text(s['label'] as String, textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentTransactions({required WidgetRef ref, required BuildContext context}) {
    final recordsAsync = ref.watch(ledgerRecordsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Recent Transactions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => context.push('/ledger'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        recordsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: Text('Error: $err')),
            ),
          ),
          data: (records) {
            if (records.isEmpty) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(48.0),
                  child: Center(child: Text('No transactions recorded yet.')),
                ),
              );
            }
            // Take only the 5 most recent records
            final recentRecords = records.take(5);
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: recentRecords.map((record) => _buildTransactionTile(record)).toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  // FULLY RESTORED PROFIT CHART — YOUR ORIGINAL ONE
  Widget _buildProfitChart(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('12-Month Profit Trend', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            SizedBox(
              height: 340,
              child: ref.watch(ledgerRecordsProvider).when(
                data: (records) {
                  if (records.isEmpty) {
                    return const Center(child: Text('No data yet'));
                  }

                  final now = DateTime.now();
                  final monthsAgo = now.subtract(const Duration(days: 365));
                  final monthly = <String, double>{};

                  for (var r in records.where((r) => r.date.isAfter(monthsAgo))) {
                    final key = DateFormat('MMM').format(r.date);
                    final amount = r.amountKobo / 100.0;
                    monthly.update(key, (v) => v + (r.type == RecordType.sale ? amount : -amount),
                        ifAbsent: () => r.type == RecordType.sale ? amount : -amount);
                  }

                  final sorted = monthly.entries.toList()
                    ..sort((a, b) => a.key.compareTo(b.key));

                  return BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (_) => Colors.grey.shade900,
                          getTooltipItem: (group, _, rod, _) {
                            return BarTooltipItem(
                              '${sorted[group.x].key}\n₦${rod.toY.abs().toStringAsFixed(0)}',
                              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 60)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= sorted.length) return const Text('');
                              return Text(sorted[index].key, style: const TextStyle(fontSize: 12));
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(show: true, drawVerticalLine: false),
                      borderData: FlBorderData(show: false),
                      barGroups: sorted.asMap().entries.map((e) {
                        final profit = e.value.value;
                        return BarChartGroupData(
                          x: e.key,
                          barRods: [
                            BarChartRodData(
                              toY: profit,
                              gradient: LinearGradient(
                                colors: profit > 0
                                    ? [Colors.green.shade400, Colors.green.shade700]
                                    : [Colors.red.shade400, Colors.red.shade700],
                              ),
                              width: 24,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                            )
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Center(child: Text('Error loading chart')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(LedgerRecord record) {
    final isSale = record.type == RecordType.sale;
    final amount = record.amountKobo / 100.0;
    final format = NumberFormat.currency(locale: 'en_NG', symbol: '₦', decimalDigits: 2);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: (isSale ? Colors.green : Colors.orange).withOpacity(0.1),
        child: Icon(
          isSale ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
          color: isSale ? Colors.green : Colors.orange,
        ),
      ),
      title: Text(record.title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(DateFormat.yMMMd().format(record.date)),
      trailing: Text(
        '${isSale ? '' : '-'}${format.format(amount)}',
        style: TextStyle(color: isSale ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}