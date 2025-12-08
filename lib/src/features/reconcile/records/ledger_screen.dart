import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:new_new_microbiz_wallet/src/domain/record.dart';
import 'package:new_new_microbiz_wallet/src/state/ledger_providers.dart';
import 'package:new_new_microbiz_wallet/src/widgets/curved_header.dart';

class LedgerScreen extends ConsumerWidget {
  const LedgerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(ledgerRecordsProvider);

    return Scaffold(
      body: Column(
        children: [
          CurvedHeader(
            height: 140,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.go('/home'),
                ),
                const Icon(Icons.history_edu_outlined, color: Colors.white, size: 48),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Transaction History',
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
                child: recordsAsync.when(
                  data: (records) {
                    if (records.isEmpty) {
                      return const Center(child: Text('No transactions recorded yet.'));
                    }
                    // Sort records by date, most recent first
                    final sortedRecords = List<LedgerRecord>.from(records)..sort((a, b) => b.date.compareTo(a.date));

                    return RefreshIndicator(
                      onRefresh: () => Future.sync(() => ref.invalidate(ledgerRecordsProvider)),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: sortedRecords.length,
                        itemBuilder: (context, index) {
                          final record = sortedRecords[index];
                          final isSale = record.type == RecordType.sale;
                          final amountColor = isSale ? Colors.green.shade700 : Colors.red.shade700;
                          final amountPrefix = isSale ? '+' : '-';
                          final amountFormatted = '₦${(record.amountKobo / 100).toStringAsFixed(2)}';
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: ListTile(
                              leading: Icon(
                                isSale ? Icons.arrow_downward : Icons.arrow_upward,
                                color: amountColor,
                              ),
                              title: Text(record.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(DateFormat.yMMMd().format(record.date)),
                              trailing: Text(
                                '$amountPrefix$amountFormatted',
                                style: TextStyle(
                                  color: amountColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              onTap: () => context.push('/record-detail', extra: record),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.add_chart_sharp),
                  title: const Text('Add Sale'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/add-sales');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.request_quote_outlined),
                  title: const Text('Add Expense'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/add-expenses');
                  },
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}