import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/theme.dart';
import '../../widgets/curved_header.dart';

class FinancingScreen extends StatelessWidget {
  const FinancingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          CurvedHeader(
            height: isWeb ? 200 : 160,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(isWeb ? 64 : 20, 50, 20, 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.go('/home'),
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 32),
                    ),
                    const Icon(Icons.account_balance_rounded, color: Colors.white, size: 60),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Text(
                        'Financing & Growth',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isWeb ? 42 : 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: GridView.count(
              padding: EdgeInsets.all(isWeb ? 40 : 16),
              crossAxisCount: isWeb ? 3 : 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: isWeb ? 1.75 : 1.45, // THE MAGIC NUMBER
              children: [
                _card(context, 'Credit Score', 'Check your business credit readiness', Icons.bar_chart_rounded, const LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)]), '/credit-score'),
                _card(context, 'Loan Status', 'Track your loan applications', Icons.history_edu_rounded, const LinearGradient(colors: [Color(0xFF00B894), Color(0xFF55E6C1)]), '/loan-status'),
                _card(context, 'Apply for Loan', 'Get funding for your business', Icons.request_page_rounded, const LinearGradient(colors: [Color(0xFFFD79A8), Color(0xFFFDCFE8)]), '/apply-for-loan'),
                _card(context, 'Connect Bank', 'Link account for instant verification', Icons.account_balance_rounded, const LinearGradient(colors: [Color(0xFF0984E3), Color(0xFF74B9FF)]), '/bank-connect'),
                _card(context, 'Government Support', 'Grants, SMEDAN, BOI programs', Icons.volunteer_activism_rounded, const LinearGradient(colors: [Color(0xFFFF7675), Color(0xFFFDCB6E)]), '/support'),
                _card(context, 'Auto-Reconcile', 'Match bank transactions automatically', Icons.sync_alt_rounded, const LinearGradient(colors: [Color(0xFF00CEC9), Color(0xFF81ECEC)]), '/recon'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, String title, String subtitle, IconData icon, Gradient gradient, String route) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push(route),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: gradient),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Icon
              Icon(icon, size: 44, color: Colors.white),

              const SizedBox(height: 16),

              // Title
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Subtitle — takes all remaining space safely
              Expanded(
                child: Text(
                  subtitle,
                  style: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 13.5, height: 1.4),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Arrow
              const Align(
                alignment: Alignment.bottomRight,
                child: Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }
}