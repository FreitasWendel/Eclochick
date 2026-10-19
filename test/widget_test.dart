import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:eclochick/main.dart';
import 'package:eclochick/services/relatorio_service.dart';
import 'package:eclochick/services/notification_service.dart';
import 'package:eclochick/services/ciclo_notification_manager.dart';

class MockRelatorioService extends Mock implements RelatorioService {}

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  testWidgets('tela inicial exibe o nome do aplicativo',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final mockRelatorio = MockRelatorioService();
    final mockNotif = MockNotificationService();

    when(() => mockNotif.initialize()).thenAnswer((_) async {});
    when(() => mockNotif.requestPermission()).thenAnswer((_) async => true);
    when(() => mockNotif.showNotification(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        )).thenAnswer((_) async {});

    final cicloManager = CicloNotificationManager(mockNotif);

    await tester.pumpWidget(
      EclochickApp(
        relatorioService: mockRelatorio,
        cicloNotificationManager: cicloManager,
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Eclochick'), findsOneWidget);
  });
}