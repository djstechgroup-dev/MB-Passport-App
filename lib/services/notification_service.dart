import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  NotificationService._internal();

  Future<void> initNotification() async {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@drawable/ic_myrtlebeachpassport');
    //Darwin for IOS
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) {

      },
      notificationCategories: [
        const DarwinNotificationCategory(
          'demoCategory',
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        ),
      ],
    );
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> requestPermission() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> cancelAllNotifications() async {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> showNotifications(int id, String title, String body, int seconds) async {
    tz.initializeTimeZones();
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id, title, body,
      tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'main_channel',
          'Main Channel',
          importance: Importance.max,
          priority: Priority.max,
          enableLights: true,
          icon: '@drawable/ic_myrtlebeachpassport',
          color: Colors.white,
          ongoing: false,
        ),
        iOS: DarwinNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}