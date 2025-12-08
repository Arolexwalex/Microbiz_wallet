import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod for ref
import 'package:new_new_microbiz_wallet/src/theme/theme.dart';
import '../../widgets/curved_header.dart';
import 'invoice_providers.dart'; // Import the new centralized providers
import '../../utils/utils.dart';

class InvoiceListScreen extends ConsumerWidget {
  const InvoiceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoices = ref.watch(invoicesProvider);
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
                const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 56),
                const SizedBox(width: 20),
                Text('Invoices', style: TextStyle(color: Colors.white, fontSize: isWeb ? 36 : 28, fontWeight: FontWeight.bold)),
                const Spacer(),
                FloatingActionButton(onPressed: () => context.push('/invoice/create'), child: const Icon(Icons.add, color: Colors.white), backgroundColor: Colors.white24),
              ]),
            ),
          ),
        ),

        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: invoices.when(
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Text('Error loading invoices'),
                data: (list) => list.isEmpty
                    ? const Center(child: Text('No invoices yet.\nTap + to create one!', textAlign: TextAlign.center, style: TextStyle(fontSize: 18)))
                    : ListView.builder(
                        padding: EdgeInsets.all(isWeb ? 32 : 16),
                        itemCount: list.length,
                        itemBuilder: (_, i) {
                          final inv = list[i];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 6,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(20),
                              title: Text(inv.customerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              subtitle: Text('#${inv.invoiceNumber} • Due ${inv.dueDate.toLocal().toShortDateString()}'),
                              trailing: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
                                Text('₦${inv.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                Text(inv.status, style: TextStyle(color: _statusColor(inv.status), fontWeight: FontWeight.w600)),
                              ]),
                              onTap: () => context.push('/invoice/${inv.id}'),
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

  Color _statusColor(String s) => {
        'Paid': Colors.green,
        'Pending': Colors.orange,
        'Overdue': Colors.red,
      }[s] ?? Colors.grey;
}