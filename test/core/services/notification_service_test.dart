import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/core/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:inicie/core/services/timezone_service.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:permission_handler/permission_handler.dart';

import 'notification_service_test.mocks.dart';

@GenerateMocks([FlutterLocalNotificationsPlugin])
@GenerateNiceMocks([MockSpec<TimezoneService>(as: #MockTimezoneService)])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late NotificationService notificationService;
  late MockFlutterLocalNotificationsPlugin mockPlugin;
  late MockTimezoneService mockTimezoneService;

  setUp(() async {
    mockPlugin = MockFlutterLocalNotificationsPlugin();
    mockTimezoneService = MockTimezoneService();

    notificationService = NotificationService(
      notificationsPlugin: mockPlugin,
      timezoneService: mockTimezoneService,
    );

    tz.initializeTimeZones();
    final location = tz.getLocation('America/New_York');
    tz.setLocalLocation(location);

    when(
      mockTimezoneService.getLocalTimezone(),
    ).thenAnswer((_) async => 'America/New_York');
    when(mockTimezoneService.getLocation(any)).thenReturn(location);

    when(
      mockPlugin.initialize(
        any,
        onDidReceiveNotificationResponse: anyNamed(
          'onDidReceiveNotificationResponse',
        ),
        onDidReceiveBackgroundNotificationResponse: anyNamed(
          'onDidReceiveBackgroundNotificationResponse',
        ),
      ),
    ).thenAnswer((_) async => true);

    await notificationService.init();

    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('flutter.baseflow.com/permissions/methods'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'requestPermissions') {
              return {Permission.notification.value: 1}; // 1 for granted
            }
            return null;
          },
        );
  });

  group('NotificationService', () {
    test('init initializes the plugin and sets local timezone', () async {
      verify(
        mockPlugin.initialize(
          any,
          onDidReceiveNotificationResponse: anyNamed(
            'onDidReceiveNotificationResponse',
          ),
          onDidReceiveBackgroundNotificationResponse: anyNamed(
            'onDidReceiveBackgroundNotificationResponse',
          ),
        ),
      ).called(1);
      verify(mockTimezoneService.getLocalTimezone()).called(1);
      verify(mockTimezoneService.initializeTimeZones()).called(1);
    });

    test('requestPermissions requests notification permission', () async {
      final result = await notificationService.requestPermissions();
      expect(result, isTrue);
    });

    test('scheduleNotification schedules a notification', () async {
      final tTask = Task(
        id: '1',
        title: 'Test Task',
        description: 'Description',
        reminderDateTime: DateTime.now().add(const Duration(days: 1)),
      );

      await notificationService.scheduleNotification(tTask);
    });

    test('cancelNotification cancels a notification', () async {
      const taskId = '1';
      when(mockPlugin.cancel(any)).thenAnswer((_) async => {});

      await notificationService.cancelNotification(taskId);

      verify(mockPlugin.cancel(taskId.hashCode)).called(1);
    });
  });
}
