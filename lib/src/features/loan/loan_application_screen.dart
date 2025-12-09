// lib/src/features/loan/loan_application_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/theme.dart';
import '../../widgets/curved_header.dart';
import 'loan_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoanApplicationScreen extends ConsumerStatefulWidget {
  final String lender;
  const LoanApplicationScreen({super.key, required this.lender});

  @override
  ConsumerState<LoanApplicationScreen> createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends ConsumerState<LoanApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  // Declare controllers, but initialize them in initState
  late final TextEditingController _businessNameCtrl;
  late final TextEditingController _amountCtrl;
  late final TextEditingController _purposeCtrl;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill the form with data from the Supabase user
    final user = Supabase.instance.client.auth.currentUser;
    _businessNameCtrl = TextEditingController(text: user?.userMetadata?['username'] ?? '');
    _amountCtrl = TextEditingController(text: '500000');
    _purposeCtrl = TextEditingController(text: 'Buy more inventory');
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    final user = Supabase.instance.client.auth.currentUser;

    try {
      await ref.read(loanRepositoryProvider).submitApplication(
            businessName: _businessNameCtrl.text.trim(),
            amount: int.parse(_amountCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')),
            purpose: _purposeCtrl.text.trim(),
            lender: widget.lender,
          );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Application sent to ${widget.lender}!'), backgroundColor: Colors.green),
      );
      context.go('/financing');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  void dispose() {
    _businessNameCtrl.dispose();
    _amountCtrl.dispose();
    _purposeCtrl.dispose();
    super.dispose();
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
                  IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back, color: Colors.white)),
                  const Icon(Icons.request_page_rounded, color: Colors.white, size: 48),
                  const SizedBox(width: 16),
                  Text('Apply to ${widget.lender}', style: TextStyle(color: Colors.white, fontSize: isWeb ? 32 : 24, fontWeight: FontWeight.bold)),
                ]),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.all(isWeb ? 40 : 20),
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Form(
                          key: _formKey,
                          child: Column(children: [
                            TextFormField(
                              controller: _businessNameCtrl,
                              decoration: const InputDecoration(labelText: 'Business Name', prefixIcon: Icon(Icons.business)),
                              validator: (v) => v!.trim().isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _amountCtrl,
                              decoration: const InputDecoration(labelText: 'Amount (₦)', prefixText: '₦ ', prefixIcon: Icon(Icons.payments)),
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _purposeCtrl,
                              decoration: const InputDecoration(labelText: 'Purpose of Loan', prefixIcon: Icon(Icons.note_alt)),
                              maxLines: 3,
                              validator: (v) => v!.trim().isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 40),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton.icon(
                                onPressed: _submitting ? null : _submit,
                                icon: _submitting ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.send),
                                label: Text(_submitting ? 'Sending...' : 'Submit Application'),
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}