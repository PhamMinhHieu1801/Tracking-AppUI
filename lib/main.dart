import 'package:booking/core/api_client.dart';
import 'package:booking/session_cache.dart';
import 'package:booking/ui/home_page_screen.dart';
import 'package:booking/ui/login.dart';
import 'package:booking/ui/new_order_screen.dart';
import 'package:booking/ui/received_order_screen.dart';
import 'package:booking/ui/ship_manage_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

import 'notification_utils.dart';

String googleApiKey = "AIzaSyBRk--4Vvu30upxmRUxyfclJZnDVG-ESI0";

Logger logger = Logger(
  printer: PrettyPrinter(methodCount: 5),
);

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await LocalNotificationService.initialize();
  LocalNotificationService.display(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configLoading();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });



  await Firebase.initializeApp();
  await SessionCache.init();

  await LocalNotificationService.initialize();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    LocalNotificationService.display(message);
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'Drawer Demo';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      builder: EasyLoading.init(),
      home: LoginScreen(),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..dismissOnTap = false;
}
