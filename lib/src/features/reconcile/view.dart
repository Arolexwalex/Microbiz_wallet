import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:new_new_microbiz_wallet/src/data/dio_provider.dart';
import 'package:new_new_microbiz_wallet/src/state/ledger_providers.dart';
import '../../theme/theme.dart';
import '../../widgets/curved_header.dart';

// ==================== STATE & PROVIDER ====================
class ReconciliationState {
  final bool isLoading;
  final String? error;
  final List<dynamic> unmatchedTransactions;

  const ReconciliationState({
    this.isLoading = false,
    this.error,
    this.unmatchedTransactions = const [],
  });

  ReconciliationState copyWith({
    bool? isLoading,
    String? error,
    List<dynamic>? unmatchedTransactions,
  }) {
    return ReconciliationState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      unmatchedTransactions: unmatchedTransactions ?? this.unmatchedTransactions,
    );
  }
}

class ReconciliationNotifier extends StateNotifier<ReconciliationState> {
  final Ref _ref;
  ReconciliationNotifier(this._ref) : super(const ReconciliationState());

  Future<void> syncAndReconcile() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final dio = _ref.read(dioProvider);
      await dio.post('/recon/sync');
      final response = await dio.post('/recon/reconcile');
      final unmatched = response.data['unmatched'] ?? <dynamic>[];

      _ref.invalidate(ledgerRecordsProvider); // Refresh dashboard

      state = state.copyWith(isLoading: false, unmatchedTransactions: unmatched);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final reconciliationProvider =
    StateNotifierProvider<ReconciliationNotifier, ReconciliationState>((ref) {
  return ReconciliationNotifier(ref);
});

// ==================== SCREEN ====================
class AutoReconScreen extends ConsumerWidget {
  const AutoReconScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reconciliationProvider);
    final notifier = ref.read(reconciliationProvider.notifier);

    // Show messages
    ref.listen<ReconciliationState>(reconciliationProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}'), backgroundColor: Colors.red),
        );
      }
      if (!next.isLoading && previous?.isLoading == true && next.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reconciliation complete!'), backgroundColor: Colors.green),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
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
                    const Icon(Icons.sync_rounded, color: Colors.white, size: 56),
                    const SizedBox(width: 20),
                    const Text(
                      'Auto-Reconciliation',
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sync Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: state.isLoading ? null : notifier.syncAndReconcile,
                          icon: state.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                )
                              : const Icon(Icons.sync),
                          label: Text(
                            state.isLoading ? 'Syncing...' : 'Sync & Reconcile Bank',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 8,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),
                      const Text('Unmatched Transactions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),

                      // Empty state
                      if (!state.isLoading && state.unmatchedTransactions.isEmpty)
                        const Card(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green, size: 64),
                                  SizedBox(height: 16),
                                  Text('All transactions matched!', style: TextStyle(fontSize: 18)),
                                ],
                              ),
                            ),
                          ),
                        ),

                      // List of unmatched
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.unmatchedTransactions.length,
                          itemBuilder: (context, index) {
                            final tx = state.unmatchedTransactions[index];
                            final amount = (tx['amountKobo'] as num? ?? 0) / 100.0;

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              elevation: 4,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.orange.shade100,
                                  child: const Icon(Icons.account_balance, color: Colors.orange),
                                ),
                                title: Text(
                                  '₦${amount.toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(tx['narration'] ?? 'No description'),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat('EEE, MMM dd, yyyy').format(DateTime.parse(tx['date'])),
                                      style: TextStyle(color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                                trailing: SizedBox(
                                  width: 100,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context.push('/add-sales', extra: {
                                        'amount': amount.toString(),
                                        'date': tx['date'],
                                        'note': tx['narration'],
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: const Text('Match', style: TextStyle(fontSize: 14)),
                                  ),
                                ),
                              ),
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
        ],
      ),
    );
  }
}