import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../theme/theme.dart';
import '../../widgets/curved_header.dart';
import 'invoice_providers.dart';

class InvoiceDetailScreen extends ConsumerWidget {
  final String invoiceId;
  const InvoiceDetailScreen({super.key, required this.invoiceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoiceAsync = ref.watch(invoiceDetailProvider(invoiceId));
    final isWeb = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: invoiceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error loading invoice')),
        data: (invoice) => invoice == null
            ? const Center(child: Text('Invoice not found'))
            : Column(
                children: [
                  // Header
                  CurvedHeader(
                    height: isWeb ? 180 : 140,
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(isWeb ? 64 : 16, 40, 16, 16),
                        child: Row(children: [
                          IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32)),
                          const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 56),
                          const SizedBox(width: 20),
                          Text('Invoice #${invoice.invoiceNumber}', style: TextStyle(color: Colors.white, fontSize: isWeb ? 36 : 28, fontWeight: FontWeight.bold)),
                        ]),
                      ),
                    ),
                  ),

                  // Scrollable Content — THIS FIXES THE OVERFLOW
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(isWeb ? 40 : 16),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 900),
                          child: Card(
                            elevation: 12,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Customer Info
                                  _infoRow('Customer', invoice.customerName, Icons.person),
                                  _infoRow('Email', invoice.customerEmail.isEmpty ? '—' : invoice.customerEmail, Icons.email),
                                  _infoRow('Phone', invoice.customerPhone.isEmpty ? '—' : invoice.customerPhone, Icons.phone),
                                  _infoRow('Issued', DateFormat('EEEE, MMM dd, yyyy').format(invoice.dateIssued), Icons.calendar_today),
                                  _infoRow('Due', DateFormat('EEEE, MMM dd, yyyy').format(invoice.dueDate), Icons.event),
                                  
                                  const SizedBox(height: 32),
                                  const Divider(),

                                  // Items Header
                                  const Text('Items', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 16),

                                  // Items List
                                  ...invoice.items.map((item) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        child: Row(
                                          children: [
                                            Expanded(flex: 3, child: Text(item.description, style: const TextStyle(fontSize: 16))),
                                            Expanded(child: Text('× ${item.quantity}', textAlign: TextAlign.center)),
                                            Expanded(child: Text('₦${item.unitPrice.toStringAsFixed(2)}', textAlign: TextAlign.end)),
                                            Expanded(child: Text('₦${(item.quantity * item.unitPrice).toStringAsFixed(2)}', textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.bold))),
                                          ],
                                        ),
                                      )),

                                  const Divider(height: 40),

                                  // Total & Status
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Chip(
                                        backgroundColor: _statusColor(invoice.status),
                                        label: Text(invoice.status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                      ),
                                      Text(
                                        'Total: ₦${invoice.totalAmount.toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 40),

                                  // Action Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 60,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.picture_as_pdf, size: 28),
                                      label: const Text('Download PDF', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red.shade600,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        elevation: 8,
                                      ),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('PDF generation coming soon!')),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _infoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    return switch (status) {
      'Paid' => Colors.green,
      'Pending' => Colors.orange,
      'Overdue' => Colors.red,
      _ => Colors.grey,
    };
  }
}