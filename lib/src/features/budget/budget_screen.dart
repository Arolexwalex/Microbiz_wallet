import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import '../../theme/theme.dart';
import '../../widgets/curved_header.dart';

final budgetProvider = StateNotifierProvider<BudgetNotifier, Map<String, double>>((ref) => BudgetNotifier());

class BudgetNotifier extends StateNotifier<Map<String, double>> {
  BudgetNotifier() : super({'limit': 0.0, 'spent': 0.0});

  void setLimit(double limit) {
    state = {...state, 'limit': limit};
  }

  void addSpent(double amount) {
    state = {...state, 'spent': state['spent']! + amount};
  }

  double getProgress() {
    final limit = state['limit']!;
    if (limit == 0) return 0.0;
    return (state['spent']! / limit).clamp(0.0, 1.0);
  }
}

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(budgetProvider);
    final budgetNotifier = ref.read(budgetProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CurvedHeader(
              height: 140,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                  const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 48),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Budget',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min, // Card should not expand to fill height
                          children: [
                            const Text(
                              'Monthly Budget',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              initialValue: budget['limit']!.toStringAsFixed(2),
                              decoration: InputDecoration(
                                labelText: 'Set Budget Limit (₦)',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.primary),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              onFieldSubmitted: (value) {
                                final limit = double.tryParse(value) ?? 0.0;
                                budgetNotifier.setLimit(limit);
                              },
                            ),
                            const SizedBox(height: 24),
                            LinearProgressIndicator(
                              value: budgetNotifier.getProgress(),
                              backgroundColor: Colors.grey[200],
                              color: budgetNotifier.getProgress() > 0.8 ? Colors.red : AppColors.primary,
                              minHeight: 10,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Spent: ₦${budget['spent']!.toStringAsFixed(2)} / Limit: ₦${budget['limit']!.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                            if (budgetNotifier.getProgress() > 0.8)
                              const Text(
                                'Warning: Approaching budget limit!',
                                style: TextStyle(fontSize: 14, color: Colors.red),
                              ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                budgetNotifier.addSpent(100.0); // Example addition
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Add Sample Expense (₦100)'),
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
}
                        