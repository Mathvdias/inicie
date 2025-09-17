import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:inicie/core/services/timezone_service.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  final TimezoneService _timezoneService;

  NotificationService({
    FlutterLocalNotificationsPlugin? notificationsPlugin,
    TimezoneService? timezoneService,
  }) : _notificationsPlugin =
           notificationsPlugin ?? FlutterLocalNotificationsPlugin(),
       _timezoneService = timezoneService ?? FlutterTimezoneService();

  Future<void> init() async {
    // Initialization settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialization settings for iOS
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _notificationsPlugin.initialize(initializationSettings);

    // Initialize the timezone database
    _timezoneService.initializeTimeZones();

    // Get the local timezone
    final String currentTimeZone = await _timezoneService.getLocalTimezone();
    _timezoneService.setLocalLocation(
      _timezoneService.getLocation(currentTimeZone),
    );
  }

  Future<bool> requestPermissions() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<void> scheduleNotification(Task task) async {
    if (task.reminderDateTime == null) return;

    final androidDetails = AndroidNotificationDetails(
      'task_reminders',
      'Task Reminders',
      channelDescription: 'Notifications for task reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    final iOSDetails = DarwinNotificationDetails();

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      task.id.hashCode, // notification id
      task.title,
      task.description ?? 'Don\'t forget!',
      tz.TZDateTime.from(task.reminderDateTime!, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(String taskId) async {
    await _notificationsPlugin.cancel(taskId.hashCode);
  }
}
