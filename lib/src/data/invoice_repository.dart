
import 'package:dio/dio.dart';
import 'package:new_new_microbiz_wallet/src/features/invoice/invoice_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dio_provider.dart'; // Import dio_provider for authenticated Dio

class InvoiceRepository {
  final Dio dio;
  InvoiceRepository(this.dio);

  Future<List<Invoice>> getInvoices() async {
    final response = await dio.get('/invoices');
    return (response.data as List).map((json) => Invoice.fromJson(json)).toList();
  }

  Future<Invoice?> getInvoiceById(String id) async {
    final response = await dio.get('/invoices/$id');
    return Invoice.fromJson(response.data);
  }

  Future<void> addInvoice(Invoice invoice) async {
    await dio.post('/invoices', data: invoice.toJson());
  }

  Future<void> updateInvoice(Invoice updatedInvoice) async {
    await dio.put('/invoices/${updatedInvoice.id}', data: updatedInvoice.toJson());
  }

  Future<void> deleteInvoice(String id) async {
    await dio.delete('/invoices/$id');
  }
}

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) => InvoiceRepository(ref.watch(dioProvider))); // Define provider here