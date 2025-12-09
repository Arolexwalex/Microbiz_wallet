import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:new_new_microbiz_wallet/src/domain/record.dart';
import 'package:new_new_microbiz_wallet/src/state/ledger_providers.dart';
import 'package:new_new_microbiz_wallet/src/theme/theme.dart';
import 'package:new_new_microbiz_wallet/src/widgets/curved_header.dart';


class AddExpensesScreen extends ConsumerStatefulWidget {
  const AddExpensesScreen({super.key});

  @override
  ConsumerState<AddExpensesScreen> createState() => _AddExpensesScreenState();
}

class _AddExpensesScreenState extends ConsumerState<AddExpensesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _category = 'General';
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submitExpense() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final amount = double.parse(_amountController.text.replaceAll(',', ''));
      // The user_id is automatically set by the database thanks to RLS policies
      final recordData = {
        'date': _selectedDate.toIso8601String(),
        'category': _category,
        'amount_kobo': (amount * 100).toInt(),
        'description': _titleController.text.trim(),
        // 'note': _noteController.text.trim(), // Your DB schema doesn't have a 'note' column yet
        'type': 'expense',
      };

      await ref.read(ledgerRepositoryProvider).createRecord(recordData);
      ref.invalidate(ledgerRecordsProvider); // Refresh the list of records

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense recorded!'), backgroundColor: Colors.red),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Beautiful Red Header
          CurvedHeader(
            height: isWeb ? 180 : 160,
            // color: Colors.red.shade600,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(isWeb ? 64 : 16, 40, 16, 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32),
                    ),
                    const Icon(Icons.request_quote_rounded, color: Colors.white, size: 56),
                    const SizedBox(width: 20),
                    Text(
                      'Record an Expense',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isWeb ? 36 : 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Form — Perfect on Mobile & Web
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 24, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Card(
                    elevation: isWeb ? 20 : 8,
                    shadowColor: Colors.red.withOpacity(0.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Enter Expense Details',
                              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),

                            _buildTextField(_titleController, 'Expense Title *', Icons.title),
                            const SizedBox(height: 24),

                            _buildTextField(
                              _amountController,
                              'Amount (₦) *',
                              Icons.payments_rounded,
                              keyboardType: TextInputType.number,
                              prefixText: '₦ ',
                              validator: (v) {
                                if (v?.trim().isEmpty ?? true) return 'Required';
                                if (double.tryParse(v!.replaceAll(',', '')) == null) return 'Invalid amount';
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            DropdownButtonFormField<String>(
                              value: _category,
                              decoration: _inputDecoration('Category', Icons.category_rounded),
                              items: ['General', 'Supplies', 'Rent', 'Utilities', 'Transport', 'Other']
                                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                  .toList(),
                              onChanged: (v) => setState(() => _category = v!),
                            ),
                            const SizedBox(height: 24),

                            TextFormField(
                              controller: _noteController,
                              decoration: _inputDecoration('Note (optional)', Icons.note_alt_rounded),
                              maxLines: 4,
                            ),
                            const SizedBox(height: 24),

                            Card(
                              child: ListTile(
                                leading: Icon(Icons.calendar_today_rounded, color: Colors.red.shade600),
                                title: Text('Date: ${DateFormat('EEEE, MMMM dd, yyyy').format(_selectedDate)}'),
                                trailing: OutlinedButton.icon(
                                  icon: const Icon(Icons.edit_calendar),
                                  label: const Text('Change'),
                                  onPressed: _selectDate,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),

                            ElevatedButton(
                              onPressed: _isLoading ? null : _submitExpense,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade600,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 12,
                                shadowColor: Colors.red.withOpacity(0.4),
                              ),
                              child: _isLoading
                                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                                  : const Text('Save Expense', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
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

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? keyboardType,
    String? prefixText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label, icon).copyWith(prefixText: prefixText),
      validator: validator ?? (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.red.shade600),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.red.shade600, width: 2.5)),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}