import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime {
  String toShortDateString() {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }
}

Color getStatusColor(String status) {
  switch (status) {
    case 'Paid':
      return Colors.green;
    case 'Overdue':
      return Colors.red;
    default:
      return Colors.orange;
  }
}