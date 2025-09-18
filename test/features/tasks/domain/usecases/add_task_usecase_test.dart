import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/core/services/notification_service.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/features/tasks/domain/repositories/task_repository.dart';
import 'package:inicie/features/tasks/domain/usecases/add_task_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_task_usecase_test.mocks.dart';

@GenerateMocks([TaskRepository, NotificationService])
void main() {
  late AddTaskUseCase addTaskUseCase;
  late MockTaskRepository mockTaskRepository;
  late MockNotificationService mockNotificationService;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    mockNotificationService = MockNotificationService();
    addTaskUseCase = AddTaskUseCase(mockTaskRepository, mockNotificationService);
  });

  group('AddTaskUseCase', () {
    final tTask = Task(id: '1', title: 'Test Task');

    test('should add a task to the repository', () async {
      // Arrange
      when(mockTaskRepository.addTask(any)).thenAnswer((_) async => Future.value());
      when(mockNotificationService.scheduleNotification(any)).thenAnswer((_) async => Future.value());

      // Act
      await addTaskUseCase(title: tTask.title);

      // Assert
      verify(mockTaskRepository.addTask(any));
      verifyNoMoreInteractions(mockTaskRepository);
      verifyZeroInteractions(mockNotificationService); // No reminder, so no notification scheduled
    });

    test('should schedule a notification if reminderDateTime is provided', () async {
      // Arrange
      final taskWithReminder = tTask.copyWith(reminderDateTime: DateTime.now().add(const Duration(days: 1)));
      when(mockTaskRepository.addTask(any)).thenAnswer((_) async => Future.value());
      when(mockNotificationService.scheduleNotification(any)).thenAnswer((_) async => Future.value());

      // Act
      await addTaskUseCase(title: taskWithReminder.title, reminderDateTime: taskWithReminder.reminderDateTime);

      // Assert
      verify(mockTaskRepository.addTask(any));
      verify(mockNotificationService.scheduleNotification(any));
      verifyNoMoreInteractions(mockTaskRepository);
      verifyNoMoreInteractions(mockNotificationService);
    });

    test('should throw an exception if title is empty', () async {
      // Act & Assert
      expect(
        () => addTaskUseCase(title: ''),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', 'Exception: Title cannot be empty.')),
      );
      verifyZeroInteractions(mockTaskRepository);
      verifyZeroInteractions(mockNotificationService);
    });
  });
}
