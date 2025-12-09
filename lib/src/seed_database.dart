import 'dart:math';
import 'package:supabase/supabase.dart';

/// A standalone script to populate the Supabase database with realistic mock ledger data.
///
/// To run this script:
/// 1. Make sure you have a `tool` directory in your project root.
/// 2. Save this file as `tool/seed_database.dart`.
/// 3. Update the placeholder credentials below.
/// 4. Run from your terminal: `dart run tool/seed_database.dart`
Future<void> main() async {
  // --- CONFIGURATION ---
  // TODO: Replace with your actual Supabase URL and anon key.
  const supabaseUrl = 'https://mpgllgcpbhzwrvviwcml.supabase.co';
  const supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1wZ2xsZ2NwYmh6d3J2dml3Y21sIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUyMzgwNDksImV4cCI6MjA4MDgxNDA0OX0.TrMWY6kBcEsveFpzrj7pM5lal1PKhBwLewOlJcDqvSU';

  // TODO: Replace with the email and password of the user you want to own this data.
  // You MUST log in, so that `auth.uid()` works for the RLS policies on the 'ledger' table.
  const userEmail = 'arolexwalex33@gmail.com';
  const userPassword = 'password';
  // --- END CONFIGURATION ---

  // 1. Initialize Supabase
  print('Connecting to Supabase...');
  // Use the pure Dart SupabaseClient
  final supabase = SupabaseClient(supabaseUrl, supabaseAnonKey);

  // 2. Sign in as the target user
  print('Signing in as $userEmail...');
  try {
    final authResponse = await supabase.auth.signInWithPassword(
      email: userEmail,
      password: userPassword,
    );
    if (authResponse.user == null) {
      print('Error: Login failed. Please check user credentials.');
      return;
    }
    print('Sign-in successful. User ID: ${authResponse.user!.id}');
  } catch (e) {
    print('Error during sign-in: $e');
    print('\nPlease ensure the user exists and you have confirmed their email address.');
    return;
  }

  // 3. Generate and insert data
  print('\nStarting data generation for the last 12 months...');
  final random = Random();
  final now = DateTime.now();
  final List<Map<String, dynamic>> allRecords = [];

  final salesCategories = ['Product Sales', 'Service Fees', 'Consulting', 'Online Orders'];
  final expenseCategories = ['Supplies', 'Rent', 'Utilities', 'Transport', 'Marketing', 'Salaries'];

  for (int i = 11; i >= 0; i--) {
    final month = DateTime(now.year, now.month - i, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    print('Generating data for ${month.year}-${month.month.toString().padLeft(2, '0')}...');

    // Generate a random number of sales for the month
    final salesCount = 50 + random.nextInt(100); // 50 to 149 sales
    for (int j = 0; j < salesCount; j++) {
      allRecords.add({
        'date': DateTime(month.year, month.month, 1 + random.nextInt(daysInMonth)).toIso8601String(),
        'description': 'Sale of Item #${random.nextInt(1000)}',
        'amount_kobo': (10000 + random.nextInt(150000)) * 100, // ₦10k to ₦150k
        'type': 'sale',
        'category': salesCategories[random.nextInt(salesCategories.length)],
      });
    }

    // Generate a smaller number of expenses
    final expensesCount = 20 + random.nextInt(40); // 20 to 59 expenses
    for (int k = 0; k < expensesCount; k++) {
      allRecords.add({
        'date': DateTime(month.year, month.month, 1 + random.nextInt(daysInMonth)).toIso8601String(),
        'description': 'Payment for ${expenseCategories[random.nextInt(expenseCategories.length)]}',
        'amount_kobo': (5000 + random.nextInt(80000)) * 100, // ₦5k to ₦80k
        'type': 'expense',
        'category': expenseCategories[random.nextInt(expenseCategories.length)],
      });
    }
  }

  print('\nGenerated a total of ${allRecords.length} records.');

  // 4. Insert data into Supabase
  try {
    print('Inserting records into the database... (this may take a moment)');
    // We insert in chunks to avoid hitting request size limits.
    const chunkSize = 500;
    for (var i = 0; i < allRecords.length; i += chunkSize) {
      final chunk = allRecords.sublist(i, i + chunkSize > allRecords.length ? allRecords.length : i + chunkSize);
      await supabase.from('ledger').insert(chunk);
      print('  ...inserted ${i + chunk.length} of ${allRecords.length} records');
    }

    print('\n✅ Success! Database has been populated with mock data.');
  } catch (e) {
    print('\n❌ Error inserting data: $e');
  } finally {
    await supabase.auth.signOut();
    print('Signed out.');
  }
}