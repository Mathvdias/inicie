import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/core/services/notification_service.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/features/tasks/domain/repositories/task_repository.dart';
import 'package:inicie/features/tasks/domain/usecases/toggle_task_completion_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'toggle_task_completion_usecase_test.mocks.dart';

@GenerateMocks([TaskRepository, NotificationService])
void main() {
  late ToggleTaskCompletionUseCase toggleTaskCompletionUseCase;
  late MockTaskRepository mockTaskRepository;
  late MockNotificationService mockNotificationService;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    mockNotificationService = MockNotificationService();
    toggleTaskCompletionUseCase = ToggleTaskCompletionUseCase(mockTaskRepository, mockNotificationService);
  });

  group('ToggleTaskCompletionUseCase', () {
    final tTask = Task(id: '1', title: 'Test Task', isCompleted: false);
    final tCompletedTask = tTask.copyWith(isCompleted: true);
    final tIncompleteTask = tTask.copyWith(isCompleted: false);

    test('should mark a task as completed and cancel notification', () async {
      // Arrange
      when(mockTaskRepository.updateTask(any)).thenAnswer((_) async => Future.value());
      when(mockNotificationService.cancelNotification(any)).thenAnswer((_) async => Future.value());

      // Act
      await toggleTaskCompletionUseCase(tIncompleteTask);

      // Assert
      verify(mockTaskRepository.updateTask(tCompletedTask));
      verify(mockNotificationService.cancelNotification(tIncompleteTask.id));
      verifyNoMoreInteractions(mockTaskRepository);
      verifyNoMoreInteractions(mockNotificationService);
    });

    test('should mark a task as incomplete and not cancel notification', () async {
      // Arrange
      when(mockTaskRepository.updateTask(any)).thenAnswer((_) async => Future.value());
      when(mockNotificationService.cancelNotification(any)).thenAnswer((_) async => Future.value());

      // Act
      await toggleTaskCompletionUseCase(tCompletedTask);

      // Assert
      verify(mockTaskRepository.updateTask(tIncompleteTask));
      verifyNoMoreInteractions(mockTaskRepository);
      verifyZeroInteractions(mockNotificationService); // Notification should not be cancelled if marking incomplete
    });
  });
}
