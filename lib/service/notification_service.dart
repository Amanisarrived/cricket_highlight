import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  Future<void> init(BuildContext context) async {
    // 1️⃣ Permission
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2️⃣ Token (for debug only)
    final token = await _firebaseMessaging.getToken();
    debugPrint("🔥 FCM Token: $token");

    // 3️⃣ 🔥 SUBSCRIBE TO TOPIC (MAIN THING)
    await FirebaseMessaging.instance.subscribeToTopic("cricket_updates");
    debugPrint("✅ Subscribed to cricket_updates");

    // 4️⃣ Local notification init
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint("👉 Notification clicked");
      },
    );

    // 5️⃣ Foreground notification
    FirebaseMessaging.onMessage.listen((message) {
      _showNotification(message);
    });

    // 6️⃣ Background notification click
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("👉 App opened from background");
    });

    // 7️⃣ Killed state notification click
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      debugPrint("👉 App opened from terminated state");
    }
  }

  void _showNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'cricket_channel',
      'Cricket Updates',
      channelDescription: 'Match updates & alerts',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails =
    NotificationDetails(android: androidDetails);

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      notificationDetails,
    );
  }
}
