import 'package:fcm_notification_app/res/constants/app_colors.dart';
import 'package:fcm_notification_app/widgets/app_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationDetailsScreen extends StatelessWidget {
  final RemoteMessage notification;

  NotificationDetailsScreen({required this.notification});

  @override
  Widget build(BuildContext context) {
    final String title = notification.notification?.title ?? 'No Title';
    final String body = notification.notification?.body ?? 'No Body';
    final Map<String, dynamic> data = notification.data;
    final String details = data.isNotEmpty ? data.toString() : 'If we have further details. It will be shown here';

    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Color(kGreen.value),
        title: 'Firebase Notifications',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title!,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              body!,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              details,
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
