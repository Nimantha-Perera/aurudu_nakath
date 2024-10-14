import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class NotificationTimeCounter {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Timer? _timer;
  int countdownTime = 60; // Starting countdown (in seconds)
  
  // Initialize notification settings
  void initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  // Start the countdown and trigger notifications
  void startCountdown(int seconds, DateTime targetTime) {
    countdownTime = seconds;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final int remainingTime = targetTime.difference(DateTime.now()).inSeconds;

      if (remainingTime <= 0) {
        _showNotification('Time’s up!', 'The event has started.');
        _timer?.cancel();
      } else {
        _showNotification(
          'Countdown Reminder',
          _getFormattedTime(remainingTime),
        );
      }
    });
  }

  // Show the notification with updated time
  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'time_counter_channel', // Channel ID
      'Time Counter', // Channel name
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      ongoing: true, // Keeps the notification in the tray until the countdown finishes
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  // Cancel the notification when necessary
  void cancelNotification() {
    _timer?.cancel();
    flutterLocalNotificationsPlugin.cancelAll();
  }

  // Format the countdown time in Sinhala
  String _getFormattedTime(int seconds) {
    final int days = seconds ~/ (24 * 3600);
    final int hours = (seconds % (24 * 3600)) ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int remainingSeconds = seconds % 60;

    List<String> parts = [];

    if (days > 0) parts.add("දින $days");
    if (hours > 0) parts.add("පැය $hours");
    if (minutes > 0) parts.add("මි $minutes");
    if (remainingSeconds > 0) parts.add("තත් $remainingSeconds");

    return parts.join(' ').trim();
  }
}
