import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_new_microbiz_wallet/src/state/auth_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'invoice_model.dart'; // Use the official Invoice model

class InvoiceRepository {
  final SupabaseClient _supabase;
  InvoiceRepository(this._supabase);

  Future<List<Invoice>> getInvoices() async {
    final data = await _supabase.from('invoices').select().order('date_issued', ascending: false);
    return data.map((item) => Invoice.fromJson(item)).toList();
  }

  /// Fetches a single invoice by its ID from Supabase.
  Future<Invoice?> getInvoiceById(int id) async {
    try {
      // Use .eq() to filter by id and .single() to get one record.
      final data = await _supabase.from('invoices').select().eq('id', id).single();
      return Invoice.fromJson(data);
    } catch (e) {
      // If .single() finds no rows, it throws an error. We return null in that case.
      return null;
    }
  }

  /// Creates a new invoice and its associated items in Supabase.
  Future<void> createInvoice(Invoice invoice) async {
    try {
      // Step 1: Insert the main invoice record and select its newly generated ID.
      final newInvoiceData = await _supabase
          .from('invoices')
          .insert(invoice.toSupabaseJson())
          .select('id')
          .single();

      final newInvoiceId = newInvoiceData['id'];

      // Step 2: Prepare the line items by adding the new invoice_id to each.
      final itemsToInsert = invoice.items.map((item) {
        // Manually create the map to ensure correct keys for Supabase
        return {
          'invoice_id': newInvoiceId,
          'description': item.description,
          'quantity': item.quantity,
          'unit_price_kobo': item.unitPriceKobo, // Use the correct integer field
        };
      }).toList();

      // Step 3: Bulk insert all the line items.
      await _supabase.from('invoice_items').insert(itemsToInsert);
    } catch (e) {
      print('Error creating invoice: $e');
      throw Exception('Failed to create invoice.');
    }
  }
}

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return InvoiceRepository(ref.watch(supabaseProvider));
});

final invoiceListProvider = FutureProvider.autoDispose<List<Invoice>>((ref) {
  // This will automatically re-fetch when the user logs in or out.
  ref.watch(authStateChangesProvider);
  return ref.watch(invoiceRepositoryProvider).getInvoices();
});

/// A provider that fetches a single invoice by its ID.
final invoiceDetailProvider = FutureProvider.family.autoDispose<Invoice?, int>((ref, id) {
  return ref.watch(invoiceRepositoryProvider).getInvoiceById(id);
});