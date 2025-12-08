// lib/src/features/loan/loan_lender_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_new_microbiz_wallet/src/theme/theme.dart';
import 'package:new_new_microbiz_wallet/src/widgets/curved_header.dart';

class LoanLenderSelectionScreen extends StatelessWidget {
  const LoanLenderSelectionScreen({super.key});

  // In a real app, this would come from a provider/API
  static const _lenders = [
    {'name': 'FairMoney', 'logo': 'assets/logos/fairmoney.png', 'description': 'Quick loans up to ₦1,000,000'},
    {'name': 'Carbon', 'logo': 'assets/logos/carbon.png', 'description': 'Personal & SME loans with flexible repayment'},
    {'name': 'Branch', 'logo': 'assets/logos/branch.png', 'description': 'Instant loans, free transfers, 20% returns'},
    {'name': 'Renmoney', 'logo': 'assets/logos/renmoney.png', 'description': 'Loans up to ₦6,000,000 for your needs'},
  ];

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
                  const Icon(Icons.request_page_rounded, color: Colors.white, size: 56),
                  const SizedBox(width: 20),
                  Text('Select a Lender', style: TextStyle(color: Colors.white, fontSize: isWeb ? 36 : 28, fontWeight: FontWeight.bold)),
                ]),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: _lenders.length,
                  itemBuilder: (context, index) {
                    final lender = _lenders[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 6,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        // leading: Image.asset(lender['logo']!, width: 40, height: 40), // Uncomment when you add logos
                        leading: const Icon(Icons.account_balance, size: 40, color: AppColors.primary),
                        title: Text(lender['name']!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        subtitle: Text(lender['description']!),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded),
                        onTap: () => context.push('/apply-for-loan/${lender['name']}'),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}