import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'screens/homepage.dart';
import 'services/relatorio_service.dart';
import 'services/flutter_notification_service.dart';
import 'services/ciclo_notification_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final plugin = FlutterLocalNotificationsPlugin();
  final notificationService = FlutterNotificationService(plugin);
  await notificationService.initialize();
  await notificationService.requestPermission();

  final cicloNotificationManager =
      CicloNotificationManager(notificationService);

  runApp(
    EclochickApp(
      relatorioService: RelatorioService(FirebaseDatabase.instance),
      cicloNotificationManager: cicloNotificationManager,
    ),
  );
}

class EclochickApp extends StatelessWidget {
  final RelatorioService? relatorioService;
  final CicloNotificationManager cicloNotificationManager;

  const EclochickApp({
    super.key,
    this.relatorioService,
    required this.cicloNotificationManager,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eclochick',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomePage(
        relatorioService: relatorioService,
        cicloNotificationManager: cicloNotificationManager,
      ),
    );
  }
}