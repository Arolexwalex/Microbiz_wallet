import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/curved_header.dart';
import '../../theme/theme.dart';
import '../../state/ledger_providers.dart';

Color _getScoreColor(double score) {
  if (score > 0.7) return Colors.green.shade700;
  if (score > 0.4) return Colors.orange.shade700;
  return Colors.red.shade700;
}

String _getHealthStatus(double score) {
  if (score > 0.7) return 'Good - Ready for loans!';
  if (score > 0.4) return 'Fair - Record more to improve';
  return 'Needs Improvement - Add sales/expenses';
}

class BusinessHealthScreen extends ConsumerWidget {
  const BusinessHealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(businessHealthProvider).when(
      data: (health) {
        String formatKobo(int kobo) => '₦${(kobo / 100).toStringAsFixed(0)}';
        
        Widget metricCard(String title, String value, String description, {Color? valueColor}) => Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(value, style: TextStyle(fontSize: 24, color: valueColor ?? AppColors.primary, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(description, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            );
        
        final metrics = [
          {'title': 'Total Sales', 'value': formatKobo(health.totalSales), 'description': 'Revenue from sales in last 30 days.'},
          {'title': 'Total Expenses', 'value': formatKobo(health.totalExpenses), 'description': 'Expenses in last 30 days.'},
          {'title': 'Total Profit', 'value': formatKobo(health.totalProfit), 'description': 'Net profit in last 30 days.'},
          {'title': 'Profit Margin', 'value': '${(health.profitMargin * 100).toStringAsFixed(0)}%', 'description': 'Sales turning into profit.'},
          {'title': 'Cash Flow', 'value': formatKobo(health.cashFlow.toInt()), 'description': 'Net cash from operations.'},
          {'title': 'Revenue Growth', 'value': '${(health.revenueGrowth * 100).toStringAsFixed(0)}%', 'description': 'Month-over-month sales increase.'},
          {'title': 'Active Days', 'value': '${health.activeDays}', 'description': 'Days with transactions in last 30 days.'},
        ];
        
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CurvedHeader(
                    height: 140,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => context.go('/home'),
                          tooltip: 'Back to Dashboard',
                        ),
                        const Icon(Icons.insights_rounded, color: Colors.white, size: 48, semanticLabel: 'Business Health Icon'),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'Business Health',
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Business Health Score',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 200,
                              child: PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(value: health.businessHealthScore * 100, color: _getScoreColor(health.businessHealthScore), title: '${(health.businessHealthScore * 100).toStringAsFixed(0)}%', titleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                                    PieChartSectionData(value: (1 - health.businessHealthScore) * 100, color: Colors.grey[300]!, showTitle: false),
                                  ],
                                  centerSpaceRadius: 60,
                                  sectionsSpace: 2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(child: Text(_getHealthStatus(health.businessHealthScore), style: TextStyle(fontSize: 18, color: _getScoreColor(health.businessHealthScore), fontWeight: FontWeight.bold))),
                            const SizedBox(height: 24),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 400,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 2.5,
                              ),
                              itemCount: metrics.length,
                              itemBuilder: (context, index) {
                                final metric = metrics[index];
                                return metricCard(metric['title'] as String, metric['value'] as String, metric['description'] as String);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }
}