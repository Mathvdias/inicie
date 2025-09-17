import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:inicie/core/services/timezone_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:inicie/utils/app_logger.dart';

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
    logger.i("NotificationService: Initialized successfully.");

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
    logger.d(
      "NotificationService: Notification permission status: ${status.isGranted}",
    );
    return status.isGranted;
  }

  Future<void> scheduleNotification(Task task) async {
    if (task.reminderDateTime == null) {
      logger.d(
        "NotificationService: Not scheduling notification for task ${task.id} - no reminderDateTime.",
      );
      return;
    }

    final scheduledTime = tz.TZDateTime.from(task.reminderDateTime!, tz.local);
    logger.d(
      "NotificationService: Attempting to schedule notification for task ${task.id} at $scheduledTime",
    );
    logger.d(
      "NotificationService: Task Title: ${task.title}, Description: ${task.description}",
    );

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

    try {
      await _notificationsPlugin.zonedSchedule(
        task.id.hashCode,
        task.title,
        task.description ?? 'Don\'t forget!',
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      logger.d(
        "NotificationService: Notification scheduled successfully for task ${task.id}.",
      );
    } catch (e) {
      logger.e(
        "NotificationService: Error scheduling notification for task ${task.id}: $e",
      );
    }
  }

  Future<void> cancelNotification(String taskId) async {
    await _notificationsPlugin.cancel(taskId.hashCode);
  }
}
