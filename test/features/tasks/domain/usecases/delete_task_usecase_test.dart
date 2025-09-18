import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/core/services/notification_service.dart';
import 'package:inicie/features/tasks/domain/repositories/task_repository.dart';
import 'package:inicie/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delete_task_usecase_test.mocks.dart';

@GenerateMocks([TaskRepository, NotificationService])
void main() {
  late DeleteTaskUseCase deleteTaskUseCase;
  late MockTaskRepository mockTaskRepository;
  late MockNotificationService mockNotificationService;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    mockNotificationService = MockNotificationService();
    deleteTaskUseCase = DeleteTaskUseCase(mockTaskRepository, mockNotificationService);
  });

  group('DeleteTaskUseCase', () {
    const tTaskId = '1';

    test('should delete a task from the repository and cancel notification', () async {
      // Arrange
      when(mockTaskRepository.deleteTask(any)).thenAnswer((_) async => Future.value());
      when(mockNotificationService.cancelNotification(any)).thenAnswer((_) async => Future.value());

      // Act
      await deleteTaskUseCase(tTaskId);

      // Assert
      verify(mockNotificationService.cancelNotification(tTaskId));
      verify(mockTaskRepository.deleteTask(tTaskId));
      verifyNoMoreInteractions(mockNotificationService);
      verifyNoMoreInteractions(mockTaskRepository);
    });
  });
}
