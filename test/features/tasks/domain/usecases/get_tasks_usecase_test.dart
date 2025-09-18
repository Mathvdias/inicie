import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/features/tasks/domain/repositories/task_repository.dart';
import 'package:inicie/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_tasks_usecase_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late GetTasksUseCase getTasksUseCase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    getTasksUseCase = GetTasksUseCase(mockTaskRepository);
  });

  group('GetTasksUseCase', () {
    final tTasks = [
      Task(id: '1', title: 'Task 1'),
      Task(id: '2', title: 'Task 2'),
    ];

    test('should get a list of tasks from the repository', () async {
      // Arrange
      when(mockTaskRepository.getTasks(limit: 20, offset: 0))
          .thenAnswer((_) async => tTasks);

      // Act
      final result = await getTasksUseCase(limit: 20, offset: 0);

      // Assert
      expect(result, tTasks);
      verify(mockTaskRepository.getTasks(limit: 20, offset: 0));
      verifyNoMoreInteractions(mockTaskRepository);
    });

    test('should get an empty list if no tasks are available', () async {
      // Arrange
      when(mockTaskRepository.getTasks(limit: 20, offset: 0))
          .thenAnswer((_) async => []);

      // Act
      final result = await getTasksUseCase(limit: 20, offset: 0);

      // Assert
      expect(result, []);
      verify(mockTaskRepository.getTasks(limit: 20, offset: 0));
      verifyNoMoreInteractions(mockTaskRepository);
    });

    test('should pass correct limit and offset to repository', () async {
      // Arrange
      const testLimit = 10;
      const testOffset = 5;
      when(mockTaskRepository.getTasks(limit: testLimit, offset: testOffset))
          .thenAnswer((_) async => tTasks);

      // Act
      final result = await getTasksUseCase(limit: testLimit, offset: testOffset);

      // Assert
      expect(result, tTasks);
      verify(mockTaskRepository.getTasks(limit: testLimit, offset: testOffset));
      verifyNoMoreInteractions(mockTaskRepository);
    });
  });
}
