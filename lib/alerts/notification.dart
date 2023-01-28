/// Notification helper functions

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_fit/alerts/alert.dart';
import 'package:get_fit/helper/local_storage.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../time/time.dart';

class NotificationController {
  late NotificationDetails notificationDetails;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late BuildContext _context;
  final weekdays = {
    1: 'Monday',
    2: 'Tuesday',
    3: 'Wednesday',
    4: 'Thursday',
    5: 'Friday',
    6: 'Saturday',
    7: 'Sunday'
  };

  NotificationController() {
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);
    // Create notificationDetails object for notifications
    notificationDetails =
        const NotificationDetails(iOS: darwinNotificationDetails);
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('EST'));
  }

  void setContext(BuildContext context) {
    _context = context;
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    if (kDebugMode) {
      print("Received local notification: $id, $title");
    }
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null && kDebugMode) {
      print('Receive notification: $payload');
    }
  }

  // Setup notifications
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

  /// Show a notification
  showNotification(String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails);
  }

  /// Schedule a notification
  scheduleNotification(Duration time,
      {int id = 0, String title = "Title", String body = "Body"}) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(id, title, body,
        tz.TZDateTime.now(tz.local).add(time), notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  /// Cancel a scheduled notification
  cancelScheduleNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  /// Cancel all scheduled notifications
  cancelAllScheduledNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Schedule notifications based on user's weekly schedule
  Future<bool> scheduleWeekNotifications(
      Map<String, Map<String, String>> schedule) async {
    Map<String, String> notifications = {};
    Map<int, Duration> toBeScheduled = {};
    DateTime currentDT = DateTime.now();
    late String newDate;

    /// Runs 7 times for each day of the week
    for (int i = 0; i < 7; i++) {
      DateTime addedDays = currentDT.add(Duration(days: i));
      newDate = addedDays.toString().substring(0, 11);
      try {
        // Find a random time during that day's gym schedule
        String newDTString = newDate +
            await pickRandomTime(
                schedule[weekdays[addedDays.weekday]]!["Start"]!,
                schedule[weekdays[addedDays.weekday]]!["End"]!);
        DateTime newDT = DateTime.parse(newDTString);

        // Schedule notification at that time if day is not a rest day
        if (schedule[weekdays[newDT.weekday]]!["rest"] == "F") {
          Duration difference = newDT.difference(currentDT);
          if (difference.inSeconds > 0) {
            toBeScheduled[addedDays.weekday] = difference;
            notifications[newDT.weekday.toString()] = newDTString;
          }
        }
      } catch (e) {
        // Show alert if there's a date error. i.e scheduling gym from 12:30 PM to 11:30 AM
        showAlert1Action(
            _context,
            "Date Error",
            "\nThere is an error on ${weekdays[addedDays.weekday]}",
            "Ok",
            null);
        return false;
      }

      await cancelAllScheduledNotifications();
      for (var day in toBeScheduled.keys) {
        await scheduleNotification(toBeScheduled[day]!,
            id: day,
            title: "Prove you're getting fit",
            body: "Take an image to prove you are at the gym");
      }
    }

    // Make Sunday notification @ 9AM to confirm schedule
    String sundayDTString = newDate + "09:00:00";
    DateTime sundayDT = DateTime.parse(sundayDTString);
    await scheduleNotification(sundayDT.difference(currentDT),
        id: 8,
        title: "Confirm Schedule",
        body: "Please confirm your workout schedule for this week");
    notifications["8"] = sundayDTString;

    await saveToStorage('notifications', jsonEncode(notifications));
    return true;
  }
}
