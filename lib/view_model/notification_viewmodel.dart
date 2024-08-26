import 'package:fcm_notification_app/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../data/services/notification_services.dart';
import '../data/services/notification_storage_service.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationStorageService _storageService;
  final NotificationService _notificationService;
  List<RemoteMessage> _notifications = [];

  NotificationViewModel(this._storageService, this._notificationService);

  List<RemoteMessage> get notifications => _notifications;

  Future<void> requestNotificationPermission() async {
    await _notificationService.requestNotificationPermission();
  }

  Future<void> getDeviceToken() async {

    try{
      final token = await FirebaseMessaging.instance.getToken();
      debugPrint("Device Token: $token");

    }catch(e){

      UtilMessage().toastMessage(e.toString());
    }

  }

  void handleForegroundMessage(RemoteMessage message) {
    try{
      _notifications.add(message);
      _storageService.saveNotification(message);
      notifyListeners();

    }catch(e){
      UtilMessage().toastMessage(e.toString());
    }

  }

  void handleBackgroundMessage(RemoteMessage message) {
    try{
      _notifications.add(message);
      _storageService.saveNotification(message);
      notifyListeners();
    }catch(e){
      UtilMessage().toastMessage(e.toString());
    }

  }

  void handleTerminatedMessage(RemoteMessage message) {
    try{
      _notifications.add(message);
      _storageService.saveNotification(message);
      notifyListeners();
    }catch(e){

      UtilMessage().toastMessage(e.toString());
    }

  }

  Future<void> loadStoredNotifications() async {
    try{
      _notifications = await _storageService.getStoredNotifications();
      notifyListeners();
    }catch(e){
      UtilMessage().toastMessage(e.toString());
    }

  }

  Future<void> removeNotification(int index) async {
    try{
      _notifications.removeAt(index);
      await _storageService.removeNotification(index);
      notifyListeners();
    }catch(e){
      UtilMessage().toastMessage(e.toString());
    }

  }
}
