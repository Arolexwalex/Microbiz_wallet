// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:new_new_microbiz_wallet/src/app.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Your MicroBizApp

final FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Init notifications
  const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings iOSInit = DarwinInitializationSettings();
  const InitializationSettings initSettings = InitializationSettings(android: androidInit, iOS: iOSInit);
  await notifications.initialize(initSettings);
  await Permission.notification.request();

  // Initialize Supabase before running the app
  await Supabase.initialize(
    url: 'https://mpgllgcpbhzwrvviwcml.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1wZ2xsZ2NwYmh6d3J2dml3Y21sIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUyMzgwNDksImV4cCI6MjA4MDgxNDA0OX0.TrMWY6kBcEsveFpzrj7pM5lal1PKhBwLewOlJcDqvSU',
  );

  runApp(const ProviderScope(child: MicroBizApp()));
}