import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationController {
  late NotificationDetails notificationDetails;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationController() {
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);
    notificationDetails =
        const NotificationDetails(iOS: darwinNotificationDetails);
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('EST'));
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print("clicked" + id.toString());
    getScheduledNotifications();
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      print('notification payload: $payload');
    }
  }

  setupNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  showNotification() async {
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', notificationDetails);
  }

  scheduleNotification(int time, {int id = 0}) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        "scheduled",
        "body",
        tz.TZDateTime.now(tz.local).add(Duration(seconds: time)),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  getScheduledNotifications() async {
    final List<ActiveNotification> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.getActiveNotifications();

    print(pendingNotificationRequests);
    return pendingNotificationRequests;
  }

  cancelScheduleNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  cancelAllScheduledNotifications() async {
    print('cancel');
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
