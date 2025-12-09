import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:new_new_microbiz_wallet/src/domain/customer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_providers.dart';

class CustomerRepository {
  final SupabaseClient _supabase;
  CustomerRepository(this._supabase);

  Future<List<Customer>> getAllCustomers() async {
    try {
      final data = await _supabase.from('customers').select().order('name', ascending: true);
      return data.map((customer) => Customer.fromMap(customer)).toList();
    } catch (e) {
      print('Customer fetch error: $e');
      throw Exception('Failed to load customers.');
    }
  }

  Future<Customer> createCustomer({
    required String name,
    String? email,
    String? phone,
    String? address,
  }) async {
    try {
      final response = await _supabase.from('customers').insert({
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      }).select().single();
      return Customer.fromMap(response);
    } catch (e) {
      throw Exception('Failed to create customer: $e');
    }
  }
}

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository(ref.watch(supabaseProvider));
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

  Future<Customer> createCustomer(String name) async {
    state = const AsyncLoading();
    final newCustomer = await _ref.read(customerRepositoryProvider).createCustomer(name: name);
    _ref.invalidate(customersProvider); // Refresh the customer list
    state = const AsyncData(null);
    return newCustomer;
  }
}