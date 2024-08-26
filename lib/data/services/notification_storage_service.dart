import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationStorageService {
  static const String _keyNotifications = 'notifications';

  Future<void> saveNotification(RemoteMessage message) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList(_keyNotifications) ?? [];

    // Convert the notification to a JSON string and store it
    notifications.add(jsonEncode({
      'messageId': message.messageId,
      'notification': {
        'title': message.notification?.title,
        'body': message.notification?.body,
      },
      'data': message.data,
    }));

    await prefs.setStringList(_keyNotifications, notifications);
  }

  Future<List<RemoteMessage>> getStoredNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList(_keyNotifications) ?? [];

    // Handle potential null or invalid JSON data
    return notifications.where((notification) {
      try {
        final data = jsonDecode(notification) as Map<String, dynamic>;
        return data.containsKey('notification') && data['notification'] != null;
      } catch (e) {
        return false;
      }
    }).map((notification) {
      try {
        final data = jsonDecode(notification) as Map<String, dynamic>;
        final notificationData = data['notification'] as Map<String, dynamic>;

        return RemoteMessage(
          messageId: data['messageId'],
          notification: RemoteNotification(
            title: notificationData['title'],
            body: notificationData['body'],
          ),
          data: data['data'],
        );
      } catch (e) {
        // Handle errors during deserialization
        return const RemoteMessage(
          notification: RemoteNotification(title: 'Error', body: 'Failed to load notification'),
        );
      }
    }).toList();
  }

  Future<void> removeNotification(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList(_keyNotifications) ?? [];

    if (index < notifications.length) {
      notifications.removeAt(index);
      await prefs.setStringList(_keyNotifications, notifications);
    }
  }
}
