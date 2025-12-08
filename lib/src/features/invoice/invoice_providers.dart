import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:new_new_microbiz_wallet/src/data/dio_provider.dart';
import 'package:new_new_microbiz_wallet/src/data/invoice_repository.dart';
import 'invoice_model.dart';

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  // Make sure you have this provider somewhere
  return InvoiceRepository(ref.read(dioProvider));
});

// List of all invoices
final invoicesProvider = FutureProvider.autoDispose<List<Invoice>>((ref) async {
  return ref.watch(invoiceRepositoryProvider).getInvoices();
});

// Single invoice by ID — THIS WAS MISSING!
final invoiceDetailProvider = FutureProvider.family<Invoice?, String>((ref, id) async {
  return ref.watch(invoiceRepositoryProvider).getInvoiceById(id);
});

// Notifier for adding invoices
final invoiceNotifierProvider = StateNotifierProvider<InvoiceNotifier, AsyncValue<void>>((ref) {
  return InvoiceNotifier(ref);
});

class InvoiceNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  InvoiceNotifier(this._ref) : super(const AsyncData(null));

  Future<void> addInvoice(Invoice invoice) async {
    state = const AsyncLoading();
    try {
      await _ref.read(invoiceRepositoryProvider).addInvoice(invoice);
      _ref.invalidate(invoicesProvider);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}