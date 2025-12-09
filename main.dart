import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_new_microbiz_wallet/src/routing/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    // These are your project's credentials from supabase.com
    url: 'https://mpgllgcpbhzwrvviwcml.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1wZ2xsZ2NwYmh6d3J2dml3Y21sIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUyMzgwNDksImV4cCI6MjA4MDgxNDA0OX0.TrMWY6kBcEsveFpzrj7pM5lal1PKhBwLewOlJcDqvSU',
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      routerConfig: router,
      title: 'myMicroBiz',
      // You can add your theme data here
    );
  }
}