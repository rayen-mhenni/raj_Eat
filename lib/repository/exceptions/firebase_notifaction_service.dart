import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseNotificationService {
  static Future<void> backgroundMessageHandler(RemoteMessage message) async {
    // Handle background messages here
  }

  static void setupFirebaseMessaging() {
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle foreground messages here
      if (message.notification != null) {
        // Show a dialog or notification here
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle message taps here
    });
  }
}
