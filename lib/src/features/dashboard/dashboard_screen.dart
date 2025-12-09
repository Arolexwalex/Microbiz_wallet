import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:new_new_microbiz_wallet/src/domain/record.dart';
import '../../state/ledger_providers.dart';
import '../../theme/theme.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  static const _services = [
    {'icon': Icons.add_chart_rounded, 'label': 'Add Sales', 'route': '/add-sales'},
    {'icon': Icons.request_quote_rounded, 'label': 'Add Expense', 'route': '/add-expenses'},
    {'icon': Icons.receipt_long_rounded, 'label': 'Invoices', 'route': '/invoices'},
    {'icon': Icons.money_off_rounded, 'label': 'Debt Tracker', 'route': '/debts'},
    {'icon': Icons.account_balance_wallet_rounded, 'label': 'Budget', 'route': '/budget'},
    {'icon': Icons.history_rounded, 'label': 'Ledger', 'route': '/ledger'},
  ];

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(ledgerRecordsProvider);
                ref.invalidate(businessHealthProvider);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isWeb ? 64 : 20, vertical: 32),
                  child: Column(
                    children: [
                      _buildHeroProfitCard(context, ref),
                      const SizedBox(height: 48),
                      _buildQuickActions(context),
                      const SizedBox(height: 48),
                      _buildRecentTransactions(context, ref),
                      const SizedBox(height: 48),
                      _buildProfitChart(context, ref),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // FIXED: Button now has fixed width → no more infinite width crash
  Widget _buildHeroProfitCard(BuildContext context, WidgetRef ref) {
 return ref.watch(businessHealthProvider).when(
      data: (health) {
        final format = NumberFormat.currency(locale: 'en_NG', symbol: '₦', decimalDigits: 0);
        final profit = health.totalProfit / 100;
        final isPositive = profit >= 0;

        return Card(
          elevation: 20,
          shadowColor: AppColors.primary.withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                colors: isPositive
                    ? [const Color(0xFF00C853), const Color(0xFF00B248)]
                    : [const Color(0xFFE53935), const Color(0xFFD32F2F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 24,
                  spacing: 32,
                  children: [
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('30-Day Net Profit', style: TextStyle(color: Colors.white70, fontSize: 18)),
                          const SizedBox(height: 16),
                          Text(
                            format.format(profit.abs()),
                            style: const TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.w900, letterSpacing: -2),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded, color: Colors.white, size: 36),
                              const SizedBox(width: 12),
                              Flexible( // Wrap the Text widget with Flexible
                                child: Text(
                                  isPositive ? 'Business is growing!' : 'Time to cut costs',
                                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        if (!isPositive) ...[
                          Icon(
                            Icons.sentiment_dissatisfied_rounded,
                            color: Colors.white.withOpacity(0.9),
                            size: 100,
                          ),
                          const SizedBox(height: 20),
                        ],
                        SizedBox(
                          width: 220, // ← THIS FIXES THE INFINITE WIDTH CRASH
                          child: ElevatedButton.icon(
                            onPressed: () => context.push('/business-health'),
                            icon: const Icon(Icons.insights_rounded),
                            label: const Text('View Report', style: TextStyle(fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: isPositive ? const Color(0xFF00C853) : const Color(0xFFE53935),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Card(
          child: SizedBox(
              height: 220, child: Center(child: CircularProgressIndicator()))),
      error: (error, stackTrace) => Card(
        color: Colors.red.shade50,
        child: SizedBox(
          height: 220,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Failed to load profit:\n$error', textAlign: TextAlign.center, style: TextStyle(color: Colors.red.shade900)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: _services.map((s) {
                return SizedBox(
                  width: 150,
                  child: Card(
                    elevation: 8,
                    shadowColor: AppColors.primary.withOpacity(0.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => context.push(s['route'] as String),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Icon(s['icon'] as IconData, size: 44, color: AppColors.primary),
                            const SizedBox(height: 12),
                            Text(
                              s['label'] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1000),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Transactions', style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
                  TextButton(onPressed: () => context.push('/ledger'), child: const Text('View all')),
                ],
              ),
              const SizedBox(height: 16),
              ref.watch(ledgerRecordsProvider).when(
                data: (records) => records.isEmpty
                    ? const Center(child: Text('No transactions yet'))
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: records.length > 6 ? 6 : records.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, i) {
                          final r = records.reversed.toList()[i];
                          final isIncome = r.type == RecordType.sale;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isIncome ? Colors.green.shade50 : Colors.red.shade50,
                              child: Icon(isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                                  color: isIncome ? Colors.green : Colors.red),
                            ),
                            title: Text(r.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text(DateFormat('EEE, MMM d • h:mm a').format(r.date)),
                            trailing: Text(
                              '₦${(r.amountKobo / 100).toStringAsFixed(0)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isIncome ? Colors.green : Colors.red,
                              ),
                            ),
                            onTap: () => context.push('/record-detail', extra: r),
                          );
                        },
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Failed to load transactions:\n$error',
                    style: TextStyle(color: Colors.red.shade900),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfitChart(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1000),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('12-Month Profit Trend', style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              SizedBox(
                height: 340, // Ensure the chart has enough space
                child: ref.watch(ledgerRecordsProvider).when(
                  data: (records) {
                    if (records.isEmpty) return const Center(child: Text('No data yet'));
                    final now = DateTime.now();
                    final monthsAgo = now.subtract(const Duration(days: 365));
                    final monthly = <String, double>{};

                    for (var r in records.where((r) => r.date.isAfter(monthsAgo))) {
                      final key = DateFormat('MMM').format(r.date);
                      final amount = r.amountKobo / 100.0;
                      monthly.update(key, (v) => v + (r.type == RecordType.sale ? amount : -amount),
                          ifAbsent: () => r.type == RecordType.sale ? amount : -amount);
                    }

                    final sorted = monthly.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

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
                          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, m) => Text(sorted[v.toInt()].key, style: const TextStyle(fontSize: 12)))),
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
                                width: 28,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                              )
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Error loading chart:\n$error',
                      style: TextStyle(color: Colors.red.shade900),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}