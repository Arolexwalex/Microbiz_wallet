import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:new_new_microbiz_wallet/src/data/dio_provider.dart';
import 'package:new_new_microbiz_wallet/src/domain/customer.dart';
import 'auth_providers.dart';

class CustomerRepository {
  final Dio _dio;
  CustomerRepository(this._dio);

  Future<List<Customer>> getAllCustomers() async {
    try {
      final response = await _dio.get('/customers');
      print('Customers API Response: ${response.data}');
      final data = response.data as List;
      return data.map((customer) => Customer.fromMap(customer)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load customers: ${e.message}');
    }
  }

  Future<Customer> createCustomer({
    required String name,
    String? email,
    String? phone,
    String? address,
  }) async {
    try {
      final response = await _dio.post('/customers', data: {
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      });
      return Customer(id: response.data['id'], name: name, email: email, phone: phone, address: address);
    } on DioException catch (e) {
      throw Exception('Failed to create customer: ${e.response?.data['message'] ?? e.message}');
    }
  }
}

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository(ref.watch(dioProvider));
});

final customersProvider = FutureProvider.autoDispose<List<Customer>>((ref) async {
  return ref.watch(customerRepositoryProvider).getAllCustomers();
});

/// Notifier for managing customer actions like creation.
final customerNotifierProvider = StateNotifierProvider<CustomerNotifier, AsyncValue<void>>((ref) {
  return CustomerNotifier(ref);
});

class CustomerNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  CustomerNotifier(this._ref) : super(const AsyncData(null));

  Future<Customer> createCustomer(Customer customer) async {
    state = const AsyncLoading();
    final newCustomer = await _ref.read(customerRepositoryProvider).createCustomer(
        name: customer.name, email: customer.email, phone: customer.phone, address: customer.address);
    _ref.invalidate(customersProvider); // Refresh the customer list
    state = const AsyncData(null);
    return newCustomer;
  }
}