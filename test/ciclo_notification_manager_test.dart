import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:eclochick/services/notification_service.dart';
import 'package:eclochick/services/ciclo_notification_manager.dart';
import 'package:eclochick/models/ciclo_incubacao.dart';

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  late MockNotificationService mockNotificationService;
  late CicloNotificationManager manager;

  setUp(() {
    mockNotificationService = MockNotificationService();
    manager = CicloNotificationManager(mockNotificationService);

    when(() => mockNotificationService.showNotification(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        )).thenAnswer((_) async => Future.value());
  });

  test('Deve notificar quando faltarem 3 dias ou menos e o ciclo estiver em andamento', () async {
    final ciclo = CicloIncubacao(id: 'ciclo-123', duracaoDias: 21);
    ciclo.iniciar();
    ciclo.dataInicio = DateTime.now().subtract(const Duration(days: 19));

    await manager.verificarCiclos([ciclo]);

    verify(() => mockNotificationService.showNotification(
          id: 'ciclo-123'.hashCode,
          title: 'Ciclo quase finalizado!',
          body: 'Faltam 2 dias para o nascimento no ciclo ciclo-123.',
        )).called(1);
  });

  test('NÃO deve notificar quando faltarem mais de 3 dias', () async {
    final ciclo = CicloIncubacao(id: 'ciclo-456', duracaoDias: 21);
    ciclo.iniciar();
    ciclo.dataInicio = DateTime.now().subtract(const Duration(days: 10));

    await manager.verificarCiclos([ciclo]);

    verifyNever(() => mockNotificationService.showNotification(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        ));
  });

  test('NÃO deve notificar ciclos que não estejam em andamento', () async {
    final ciclo = CicloIncubacao(id: 'ciclo-789', duracaoDias: 21);

    await manager.verificarCiclos([ciclo]);

    verifyNever(() => mockNotificationService.showNotification(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        ));
  });
}