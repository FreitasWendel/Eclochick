import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:eclochick/services/notification_service.dart';
import 'package:eclochick/services/ciclo_notification_manager.dart';
import 'package:eclochick/models/ciclo_incubacao.dart';

// Mock para não mostrar notificação real no celular durante o teste
class MockNotificationService extends Mock implements NotificationService {}

void main() {
  // Inicializa o ambiente de integração
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Teste de Integração - Sistema de Notificação', () {
    late MockNotificationService mockNotificationService;
    late CicloNotificationManager manager;

    setUp(() {
      mockNotificationService = MockNotificationService();
      manager = CicloNotificationManager(mockNotificationService);

      // Configura o mock para registrar as chamadas
      when(() => mockNotificationService.showNotification(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => Future.value());
    });

    testWidgets('deve integrar com o sistema e disparar notificação no ambiente do app', (WidgetTester tester) async {
      // 1. Simulamos a chegada dos dados (como se viessem do Firebase)
      // Usando exatamente a mesma lógica do teste unitário
      final ciclo = CicloIncubacao(id: 'ciclo-123', duracaoDias: 21);
      ciclo.iniciar();
      ciclo.dataInicio = DateTime.now().subtract(const Duration(days: 19));

      // 2. Executamos o gerenciador (simulando o momento em que o app sincroniza os dados)
      await manager.verificarCiclos([ciclo]);

      // 3. Verificamos se a integração funcionou e a notificação foi solicitada
      verify(() => mockNotificationService.showNotification(
            id: 'ciclo-123'.hashCode,
            title: 'Ciclo quase finalizado!',
            body: 'Faltam 2 dias para o nascimento no ciclo ciclo-123.',
          )).called(1);
          
      // Exibe uma mensagem no console para confirmar
      print('✅ Teste de Integração: Notificação disparada com sucesso no ambiente do app.');
    });
  });
}