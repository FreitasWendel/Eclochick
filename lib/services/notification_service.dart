abstract class NotificationService {
  Future<void> initialize();

  Future<bool?> requestPermission();

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  });
}