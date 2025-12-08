// lib/src/features/financing/credit_score_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:new_new_microbiz_wallet/src/providers/microbiz_scre_provider.dart';
import '../../theme/theme.dart';
import '../../widgets/curved_header.dart';


class CreditScoreScreen extends ConsumerWidget {
  const CreditScoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(microBizScoreProvider);
    final isWeb = MediaQuery.of(context).size.width > 900;

    Color getColor(int s) {
      if (s >= 750) return Colors.green.shade600;
      if (s >= 650) return Colors.orange.shade600;
      return Colors.red.shade600;
    }

    String getRating(int s) {
      if (s >= 750) return 'Excellent';
      if (s >= 700) return 'Very Good';
      if (s >= 650) return 'Good';
      if (s >= 600) return 'Fair';
      return 'Needs Improvement';
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          CurvedHeader(
            height: isWeb ? 200 : 160,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(isWeb ? 64 : 16, 50, 16, 16),
                child: Row(children: [
                  IconButton(onPressed: () => context.go('/financing'), icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32)),
                  const Icon(Icons.score_rounded, color: Colors.white, size: 56),
                  const SizedBox(width: 20),
                  Text('MicroBiz Credit Score', style: TextStyle(color: Colors.white, fontSize: isWeb ? 36 : 28, fontWeight: FontWeight.bold)),
                ]),
              ),
            ),
          ),

          // SCROLLABLE CONTENT — THIS FIXES OVERFLOW
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isWeb ? 48 : 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: [
                      // Score Circle
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: getColor(score), width: 12),
                          boxShadow: [BoxShadow(color: getColor(score).withOpacity(0.3), blurRadius: 30, spreadRadius: 10)],
                        ),
                        child: Column(
                          children: [
                            Text('$score', style: TextStyle(fontSize: 96, fontWeight: FontWeight.bold, color: getColor(score))),
                            Text(getRating(score), style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: getColor(score))),
                          ],
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Info Cards
                      _infoCard('Revenue Volume', 'Strong growth detected', Icons.trending_up_rounded, Colors.green),
                      _infoCard('Profit Health', 'Healthy margins', Icons.health_and_safety_rounded, Colors.blue),
                      _infoCard('Business Activity', '180 days active', Icons.calendar_month_rounded, Colors.purple),
                      _infoCard('Payment Behavior', 'No red flags', Icons.verified_rounded, Colors.orange),

                      const SizedBox(height: 48),

                      // Trust Message
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              const Icon(Icons.shield_rounded, size: 64, color: AppColors.primary),
                              const SizedBox(height: 16),
                              const Text('Trusted by Lenders', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              Text(
                                'Your MicroBiz Score is calculated from real business data. '
                                'Lenders like Carbon, FairMoney & Renmoney trust it — that’s why you get better rates.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () => context.go('/financing'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            elevation: 12,
                          ),
                          child: const Text('See Pre-Qualified Loans →', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(String title, String subtitle, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.2), child: Icon(icon, color: color, size: 32)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(subtitle),
      ),
    );
  }
}