import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:new_new_microbiz_wallet/src/domain/customer.dart';
import 'package:new_new_microbiz_wallet/src/state/customer_providers.dart';
import 'package:uuid/uuid.dart';
import '../../theme/theme.dart';
import '../../widgets/curved_header.dart';
import 'invoice_model.dart';
import 'invoice_providers.dart';

class InvoiceCreateScreen extends ConsumerStatefulWidget {
  const InvoiceCreateScreen({super.key});
  @override ConsumerState<InvoiceCreateScreen> createState() => _InvoiceCreateScreenState();
}

class _InvoiceCreateScreenState extends ConsumerState<InvoiceCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numberCtrl = TextEditingController();
  Customer? _customer;
  DateTime _issued = DateTime.now();
  DateTime _due = DateTime.now().add(const Duration(days: 30));
  final List<InvoiceItem> _items = [const InvoiceItem(description: '', quantity: 1, unitPrice: 0)];

  @override
  void dispose() {
    _numberCtrl.dispose();
    super.dispose();
  }

  void _addItem() => setState(() => _items.add(const InvoiceItem(description: '', quantity: 1, unitPrice: 0)));
  void _removeItem(int i) => setState(() => _items.removeAt(i));

  double get total => _items.fold(0, (s, i) => s + i.quantity * i.unitPrice);

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _customer == null) return;

    final invoice = Invoice(
      id: const Uuid().v4(),
      customerId: _customer!.id,
      customerName: _customer!.name,
      customerEmail: _customer!.email ?? '',
      customerPhone: _customer!.phone ?? '',
      invoiceNumber: _numberCtrl.text,
      dateIssued: _issued,
      dueDate: _due,
      items: _items,
      totalAmount: total,
      status: 'Pending',
    );

    await ref.read(invoiceNotifierProvider.notifier).addInvoice(invoice);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice created!')));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          CurvedHeader(
            height: isWeb ? 180 : 140,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(isWeb ? 64 : 16, 40, 16, 16),
                child: Row(children: [
                  IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32)),
                  const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 56),
                  const SizedBox(width: 20),
                  Text('Create Invoice', style: TextStyle(color: Colors.white, fontSize: isWeb ? 36 : 28, fontWeight: FontWeight.bold)),
                ]),
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Card(
                  margin: EdgeInsets.all(isWeb ? 40 : 16),
                  elevation: isWeb ? 20 : 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(children: [
                          // Customer + Number
                          Row(children: [
                            Expanded(
                              child: Consumer(builder: (context, ref, _) {
                                final customers = ref.watch(customersProvider);
                                return customers.when(
                                  data: (list) => DropdownButtonFormField<Customer>(
                                    value: _customer,
                                    decoration: _inputDec('Customer *', Icons.person),
                                    items: list.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                                    onChanged: (v) => setState(() => _customer = v),
                                    validator: (_) => _customer == null ? 'Required' : null,
                                  ),
                                  loading: () => const LinearProgressIndicator(),
                                  error: (_, __) => const Text('Error loading customers'),
                                );
                              }),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(width: 200, child: TextFormField(controller: _numberCtrl, decoration: _inputDec('Invoice #', Icons.numbers), validator: (v) => v!.isEmpty ? 'Required' : null)),
                            const SizedBox(width: 16),
                            IconButton.filled(onPressed: () => ref.read(customerNotifierProvider.notifier), icon: const Icon(Icons.add)),
                          ]),

                          const SizedBox(height: 24),

                          // Dates
                          Row(children: [
                            Expanded(child: _dateTile('Date Issued', _issued, () async {
                              final d = await showDatePicker(context: context, initialDate: _issued, firstDate: DateTime(2020), lastDate: DateTime(2100));
                              if (d != null) setState(() => _issued = d);
                            })),
                            const SizedBox(width: 16),
                            Expanded(child: _dateTile('Due Date', _due, () async {
                              final d = await showDatePicker(context: context, initialDate: _due, firstDate: _issued, lastDate: DateTime(2100));
                              if (d != null) setState(() => _due = d);
                            })),
                          ]),

                          const SizedBox(height: 32),
                          const Align(alignment: Alignment.centerLeft, child: Text('Items', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),

                          ..._items.asMap().entries.map((e) {
                            final i = e.key; final item = e.value;
                            return _ItemRow(item: item, onChanged: (newItem) => setState(() => _items[i] = newItem), onDelete: () => _removeItem(i));
                          }),

                          TextButton.icon(onPressed: _addItem, icon: const Icon(Icons.add), label: const Text('Add Item')),

                          const Divider(height: 48),

                          // Total
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text('Total: ₦${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary)),
                          ),

                          const SizedBox(height: 32),

                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: _save,
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 10),
                              child: const Text('Create Invoice', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDec(String label, IconData icon) => InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: Colors.grey.shade50,
      );

  Widget _dateTile(String label, DateTime date, VoidCallback onTap) => InkWell(
        onTap: onTap,
        child: InputDecorator(
          decoration: _inputDec(label, Icons.calendar_today),
          child: Text(DateFormat('EEEE, MMM dd, yyyy').format(date)),
        ),
      );
}

class _ItemRow extends StatelessWidget {
  final InvoiceItem item;
  final ValueChanged<InvoiceItem> onChanged;
  final VoidCallback onDelete;

  const _ItemRow({required this.item, required this.onChanged, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Expanded(flex: 4, child: TextFormField(initialValue: item.description, decoration: const InputDecoration(labelText: 'Description'), onChanged: (v) => onChanged(item.copyWith(description: v)))),
        const SizedBox(width: 8),
        SizedBox(width: 80, child: TextFormField(initialValue: item.quantity.toString(), keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Qty'), onChanged: (v) => onChanged(item.copyWith(quantity: int.tryParse(v) ?? 1)))),
        const SizedBox(width: 8),
        SizedBox(width: 120, child: TextFormField(initialValue: item.unitPrice.toStringAsFixed(2), keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price'), onChanged: (v) => onChanged(item.copyWith(unitPrice: double.tryParse(v) ?? 0)))),
        IconButton(onPressed: onDelete, icon: const Icon(Icons.delete, color: Colors.red)),
      ]),
    );
  }
}