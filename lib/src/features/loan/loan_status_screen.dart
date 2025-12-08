import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // For Riverpod if needed
import 'loan_providers.dart';
import '../../widgets/curved_header.dart';

class LoanStatusScreen extends ConsumerWidget { // Change to ConsumerWidget to use ref
  const LoanStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          CurvedHeader(
            height: 140,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                  tooltip: 'Back to Financing',
                ),
                const Icon(Icons.track_changes, color: Colors.white, size: 48),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Loan Status',
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
                constraints: const BoxConstraints(maxWidth: 800),
                child: ref.watch(loanApplicationsProvider).when(
                  data: (applications) {
                    if (applications.isEmpty) {
                      return const Center(child: Text('No loan applications submitted yet.'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: applications.length,
                      itemBuilder: (context, index) {
                        final application = applications[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: const Icon(Icons.request_page_outlined, size: 40),
                            title: Text(
                              '${application.lenderName ?? 'Loan'} Application',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Text('Amount: ₦${NumberFormat('#,##0').format(application.amountRequested)}\nApplied: ${DateFormat.yMMMd().format(application.appliedAt)}'),
                            trailing: Text(application.status, style: TextStyle(color: _getStatusColor(application.status), fontWeight: FontWeight.bold)),
                            onTap: () {
                              // Optionally navigate to a detail screen for a specific loan application
                              // context.push('/loan-status/${application.id}');
                            },
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green.shade700;
      case 'rejected':
        return Colors.red.shade700;
      case 'pending':
      default:
        return Colors.orange.shade700;
    }
  }
}