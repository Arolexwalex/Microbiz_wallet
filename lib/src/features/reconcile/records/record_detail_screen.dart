import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:new_new_microbiz_wallet/src/domain/record.dart';
import 'package:new_new_microbiz_wallet/src/widgets/curved_header.dart';


class RecordDetailScreen extends StatelessWidget {
  final LedgerRecord record;

  const RecordDetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final isSale = record.type == RecordType.sale;
    final amountColor = isSale ? Colors.green.shade700 : Colors.red.shade700;
    final amountFormatted = '₦${(record.amountKobo / 100).toStringAsFixed(2)}';

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
                ),
                const Icon(Icons.receipt_long_outlined, color: Colors.white, size: 48),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Transaction Detail',
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Title:', record.title),
                      _buildDetailRow('Amount:', amountFormatted, valueColor: amountColor),
                      _buildDetailRow('Type:', isSale ? 'Sale' : 'Expense'),
                      _buildDetailRow('Category:', record.category),
                      _buildDetailRow('Date:', DateFormat.yMMMMd().format(record.date)),
                      if (record.note.isNotEmpty)
                        _buildDetailRow('Note:', record.note),
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

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.black87,
            ),
          ),
          const Divider(height: 16),
        ],
      ),
    );
  }
}