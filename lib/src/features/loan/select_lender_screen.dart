import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_new_microbiz_wallet/src/theme/theme.dart';
import 'package:new_new_microbiz_wallet/src/widgets/curved_header.dart';

class SelectLenderScreen extends StatelessWidget {
  const SelectLenderScreen({super.key});

  // Mock data for loan providers
  final List<Map<String, String>> lenders = const [
    {'name': 'LAPO Microfinance', 'logo': 'assets/images/lapo_logo.png', 'description': 'Empowering small businesses with accessible loans.'},
    {'name': 'Renmoney', 'logo': 'assets/images/renmoney_logo.png', 'description': 'Quick and convenient loans up to ₦6,000,000.'},
    {'name': 'Carbon', 'logo': 'assets/images/carbon_logo.png', 'description': 'Simple, digital financial services for everyone.'},
    {'name': 'Fairmoney', 'logo': 'assets/images/fairmoney_logo.png', 'description': 'Instant loans and secure banking in one app.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          CurvedHeader(
            height: 160,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32),
                    ),
                    const Icon(Icons.handshake_rounded, color: Colors.white, size: 56),
                    const SizedBox(width: 20),
                    const Text(
                      'Select a Lender',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: lenders.length,
              itemBuilder: (context, index) {
                final lender = lenders[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    // leading: Image.asset(
                    //   lender['logo']!,
                    //   width: 50,
                    //   errorBuilder: (ctx, err, st) => const Icon(Icons.business_center, size: 40, color: AppColors.primary),
                    // ),
                    leading: const Icon(Icons.business_center, size: 40, color: AppColors.primary),
                    title: Text(lender['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Text(lender['description']!),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primary),
                    onTap: () => context.push('/apply-for-loan/${lender['name']}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}