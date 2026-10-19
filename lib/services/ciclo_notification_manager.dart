import 'notification_service.dart';
import '../models/ciclo_incubacao.dart';

class CicloNotificationManager {
  final NotificationService _notificationService;

  CicloNotificationManager(this._notificationService);

  Future<void> verificarCiclos(List<CicloIncubacao> ciclos) async {
    for (final ciclo in ciclos) {
      if (ciclo.estado == EstadoCiclo.emAndamento) {
        final diasRestantes = ciclo.diasRestantes();

        if (diasRestantes <= 3 && diasRestantes > 0) {
          final notificationId = ciclo.id.hashCode;

          await _notificationService.showNotification(
            id: notificationId,
            title: 'Ciclo quase finalizado!',
            body: 'Faltam $diasRestantes dias para o nascimento no ciclo ${ciclo.id}.',
          );
        }
      }
    }
  }
}