// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:new_new_microbiz_wallet/src/app.dart';
import 'package:permission_handler/permission_handler.dart';
// Your MicroBizApp

final FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Init notifications
  const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings iOSInit = DarwinInitializationSettings();
  const InitializationSettings initSettings = InitializationSettings(android: androidInit, iOS: iOSInit);
  await notifications.initialize(initSettings);
  await Permission.notification.request(); // For reminders
  runApp(const ProviderScope(child: MicroBizApp()));
}