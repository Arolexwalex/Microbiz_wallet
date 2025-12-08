import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:new_new_microbiz_wallet/src/state/budget_providers.dart';
import '../../state/ledger_providers.dart';
import '../../widgets/curved_header.dart';

final reportsProvider = Provider<ReportsService>((ref) => ReportsService(ref));

class ReportsService {
  final Ref ref;
  ReportsService(this.ref);

  Future<File> generateReport() async {
    final health = await ref.read(businessHealthProvider.future);
    final budget = ref.read(budgetProvider);
    final totals = await ref.read(todayTotalsProvider.future);
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Financial Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 20),
          pw.Text('Date: ${DateTime.now().toIso8601String().split('T')[0]}', style: pw.TextStyle(fontSize: 12)),
          pw.SizedBox(height: 20),
          pw.Text('Budget Summary', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.Text('Spent: ₦${budget['spent']!.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 14)),
          pw.Text('Limit: ₦${budget['limit']!.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 14)),
          pw.SizedBox(height: 20),
          pw.Text('Today\'s Totals', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.Text('Sales: ₦${(totals.sales / 100).toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 14)),
          pw.Text('Expenses: ₦${(totals.expenses / 100).toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 14)),
          pw.SizedBox(height: 20),
          pw.Text('Business Health', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.Text('Profit: ₦${(health.totalProfit / 100).toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 14)),
          pw.Text('Score: ${(health.businessHealthScore * 100).toStringAsFixed(0)}%', style: pw.TextStyle(fontSize: 14)),
        ],
      ),
    ));

    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/financial_report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }
}

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          CurvedHeader(
            height: 140,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                           if (GoRouter.of(context).canPop()) {
                                 context.pop();
                                     } else {
                                            context.go('/home');
                                     }
                  }
                ),
                const Icon(Icons.analytics_outlined, color: Colors.white, size: 48),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Financial Reports',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Generate Report', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      if (kIsWeb)
                        const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('PDF report generation is not available on the web. This feature is available on the mobile app.', textAlign: TextAlign.center),
                          ),
                        )
                      else
                        ElevatedButton(
                          onPressed: () async {
                            final file = await ref.read(reportsProvider).generateReport();
                            OpenFile.open(file.path);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report generated and opened')));
                          },
                          child: const Text('Create PDF Report'),
                        ),
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
}