import 'package:fcm_notification_app/data/services/firebase_messageing_service.dart';
import 'package:fcm_notification_app/view/global_key.dart';
import 'package:fcm_notification_app/view/notification_details_screen.dart';
import 'package:fcm_notification_app/view/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_model/notification_viewmodel.dart';
import 'data/services/notification_storage_service.dart';
import 'data/services/notification_services.dart'; // Import NotificationService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessagingService.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<NotificationStorageService>(
          create: (_) => NotificationStorageService(),
        ),
        Provider<NotificationService>(
          create: (_) => NotificationService(), // Provide NotificationService
        ),
        ChangeNotifierProvider<NotificationViewModel>(
          create: (context) => NotificationViewModel(
            context.read<NotificationStorageService>(),
            context.read<NotificationService>(), // Pass both services
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: scaffoldMessengerKey,
        home: SplashScreen(),
        onGenerateRoute: (settings) {
          if (settings.name == '/notificationDetails') {
            final RemoteMessage message = settings.arguments as RemoteMessage;
            return MaterialPageRoute(
              builder: (context) {
                return NotificationDetailsScreen(notification: message);
              },
            );
          }
          return null; // Return null if the route isn't found
        },
      ),
    );
  }
}
