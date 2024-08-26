import 'package:fcm_notification_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import '../view_model/notification_viewmodel.dart';
import '../widgets/app_bar.dart';
import 'package:fcm_notification_app/res/constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final notificationViewModel = context.read<NotificationViewModel>();
    notificationViewModel.requestNotificationPermission();
    notificationViewModel.getDeviceToken();
    notificationViewModel.loadStoredNotifications(); // Load notifications

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      notificationViewModel.handleForegroundMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      notificationViewModel.handleBackgroundMessage(message);
      Navigator.pushNamed(context, '/notifications');
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        notificationViewModel.handleTerminatedMessage(message);
        Navigator.pushNamed(context, '/notifications');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Color(kGreen.value),
        title: 'Notifications',
      ),
      body: Consumer<NotificationViewModel>(
        builder: (context, viewModel, child) {
          return ListView.builder(
            itemCount: viewModel.notifications.length,
            itemBuilder: (context, index) {
              final message = viewModel.notifications[index];
              return Dismissible(
                key: Key(message.messageId ?? index.toString()),
                onDismissed: (direction) {
                  viewModel.removeNotification(index);
                  Utils().toastMessage("Notification Deleted Successfully");
                },
                child: Card(
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 3),
                  child: ListTile(
                    leading: const Icon(Icons.notification_important),
                    title: Text(message.notification?.title ?? 'No Title'),
                    subtitle: Text(message.notification?.body ?? 'No Body'),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/notificationDetails',
                        arguments: message,
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
