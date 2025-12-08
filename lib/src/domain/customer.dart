import 'dart:convert';

import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? address;

  Customer({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.address,
  });

  @override
  List<Object?> get props => [id, name, email, phone, address];

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      address: map['address'] as String?,
    );
  }

  factory Customer.fromJson(String source) =>
      Customer.fromMap(json.decode(source) as Map<String, dynamic>);
}