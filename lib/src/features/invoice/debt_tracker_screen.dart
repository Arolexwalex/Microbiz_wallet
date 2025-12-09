import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod for ref
import 'package:new_new_microbiz_wallet/src/features/invoice/invoice_model.dart';
import 'package:new_new_microbiz_wallet/src/features/invoice/invoice_providers.dart';
import 'package:new_new_microbiz_wallet/src/theme/theme.dart';
import '../../widgets/curved_header.dart';
import '../../utils/utils.dart';

/// A provider that derives the list of outstanding debts from the main invoicesProvider.
/// This is efficient as it doesn't make a new network request.
final outstandingDebtsProvider = Provider<List<Invoice>>((ref) {
  final invoicesAsyncValue = ref.watch(invoiceListProvider);
  return invoicesAsyncValue.asData?.value.where((invoice) => invoice.status != 'Paid').toList() ?? [];
});

class DebtTrackerScreen extends ConsumerWidget {
  const DebtTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debts = ref.watch(outstandingDebtsProvider);
    final isWeb = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(children: [
        CurvedHeader(
          height: isWeb ? 180 : 140,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(isWeb ? 64 : 16, 40, 16, 16),
              child: Row(children: [
                IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32)),
                const Icon(Icons.money_off_rounded, color: Colors.white, size: 56),
                const SizedBox(width: 20),
                Text('Debt Tracker', style: TextStyle(color: Colors.white, fontSize: isWeb ? 36 : 28, fontWeight: FontWeight.bold)),
              ]),
            ),
          ),
        ),

        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Padding(
                padding: EdgeInsets.all(isWeb ? 40 : 16),
                child: debts.isEmpty
                    ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.check_circle, size: 80, color: Colors.green), SizedBox(height: 16), Text('No outstanding debts!', style: TextStyle(fontSize: 24))]))
                    : ListView.builder(
                        itemCount: debts.length,
                        itemBuilder: (_, i) {
                          final d = debts[i];
                          final overdue = d.dueDate.isBefore(DateTime.now()) && d.status != 'Paid';
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            elevation: 8,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(24),
                              title: Text(d.customerName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('#${d.invoiceNumber} • Due ${d.dueDate.toLocal().toShortDateString()}'),
                                if (overdue) const Text('OVERDUE', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                              ]),
                              trailing: Text('₦${d.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                              onTap: () => context.push('/invoice/${d.id}'),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}