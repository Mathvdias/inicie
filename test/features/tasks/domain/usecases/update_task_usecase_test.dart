import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/core/services/notification_service.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/features/tasks/domain/repositories/task_repository.dart';
import 'package:inicie/features/tasks/domain/usecases/update_task_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_task_usecase_test.mocks.dart';

@GenerateMocks([TaskRepository, NotificationService])
void main() {
  late UpdateTaskUseCase updateTaskUseCase;
  late MockTaskRepository mockTaskRepository;
  late MockNotificationService mockNotificationService;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    mockNotificationService = MockNotificationService();
    updateTaskUseCase = UpdateTaskUseCase(mockTaskRepository, mockNotificationService);
  });

  group('UpdateTaskUseCase', () {
    final tTask = Task(id: '1', title: 'Test Task');

    test('should update a task in the repository', () async {
      // Arrange
      when(mockTaskRepository.updateTask(any)).thenAnswer((_) async => Future.value());
      when(mockNotificationService.scheduleNotification(any)).thenAnswer((_) async => Future.value());
      when(mockNotificationService.cancelNotification(any)).thenAnswer((_) async => Future.value());

      // Act
      await updateTaskUseCase(tTask);

      // Assert
      verify(mockTaskRepository.updateTask(tTask));
      verifyNoMoreInteractions(mockTaskRepository);
      verify(mockNotificationService.cancelNotification(tTask.id)); // No reminder, so cancel any existing
      verifyNoMoreInteractions(mockNotificationService);
    });

    test('should schedule a notification if reminderDateTime is provided', () async {
      // Arrange
      final taskWithReminder = tTask.copyWith(reminderDateTime: DateTime.now().add(const Duration(days: 1)));
      when(mockTaskRepository.updateTask(any)).thenAnswer((_) async => Future.value());
      when(mockNotificationService.scheduleNotification(any)).thenAnswer((_) async => Future.value());
      when(mockNotificationService.cancelNotification(any)).thenAnswer((_) async => Future.value());

      // Act
      await updateTaskUseCase(taskWithReminder);

      // Assert
      verify(mockTaskRepository.updateTask(taskWithReminder));
      verify(mockNotificationService.scheduleNotification(taskWithReminder));
      verifyNoMoreInteractions(mockTaskRepository);
      verifyNoMoreInteractions(mockNotificationService);
    });

    test('should cancel notification if reminderDateTime is removed', () async {
      // Arrange
      final taskWithoutReminder = tTask.copyWith(reminderDateTime: null);
      when(mockTaskRepository.updateTask(any)).thenAnswer((_) async => Future.value());
      when(mockNotificationService.scheduleNotification(any)).thenAnswer((_) async => Future.value());
      when(mockNotificationService.cancelNotification(any)).thenAnswer((_) async => Future.value());

      // Act
      await updateTaskUseCase(taskWithoutReminder);

      // Assert
      verify(mockTaskRepository.updateTask(taskWithoutReminder));
      verify(mockNotificationService.cancelNotification(taskWithoutReminder.id));
      verifyNoMoreInteractions(mockTaskRepository);
      verifyNoMoreInteractions(mockNotificationService);
    });
  });
}
