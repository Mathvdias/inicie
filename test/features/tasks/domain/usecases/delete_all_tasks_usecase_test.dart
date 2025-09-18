import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/core/services/notification_service.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/features/tasks/domain/repositories/task_repository.dart';
import 'package:inicie/features/tasks/domain/usecases/delete_all_tasks_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delete_all_tasks_usecase_test.mocks.dart';

@GenerateMocks([TaskRepository, NotificationService])
void main() {
  late DeleteAllTasksUseCase deleteAllTasksUseCase;
  late MockTaskRepository mockTaskRepository;
  late MockNotificationService mockNotificationService;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    mockNotificationService = MockNotificationService();
    deleteAllTasksUseCase = DeleteAllTasksUseCase(mockTaskRepository, mockNotificationService);
  });

  group('DeleteAllTasksUseCase', () {
    final tTasks = [
      Task(id: '1', title: 'Task 1'),
      Task(id: '2', title: 'Task 2'),
    ];

    test('should delete all tasks from the repository and cancel all notifications', () async {
      // Arrange
      when(mockTaskRepository.deleteAllTasks()).thenAnswer((_) async => Future.value());
      when(mockNotificationService.cancelNotification(any)).thenAnswer((_) async => Future.value());

      // Act
      await deleteAllTasksUseCase(tTasks);

      // Assert
      verify(mockNotificationService.cancelNotification('1'));
      verify(mockNotificationService.cancelNotification('2'));
      verify(mockTaskRepository.deleteAllTasks());
      verifyNoMoreInteractions(mockNotificationService);
      verifyNoMoreInteractions(mockTaskRepository);
    });
  });
}
