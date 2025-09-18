import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/features/tasks/domain/repositories/task_repository.dart';
import 'package:inicie/features/tasks/domain/usecases/load_more_tasks_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'load_more_tasks_usecase_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late LoadMoreTasksUseCase loadMoreTasksUseCase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    loadMoreTasksUseCase = LoadMoreTasksUseCase(mockTaskRepository);
  });

  group('LoadMoreTasksUseCase', () {
    final tTasks = [
      Task(id: '1', title: 'Task 1'),
      Task(id: '2', title: 'Task 2'),
    ];

    test('should load more tasks from the repository', () async {
      // Arrange
      const testLimit = 10;
      const testOffset = 20;
      when(mockTaskRepository.getTasks(limit: testLimit, offset: testOffset))
          .thenAnswer((_) async => tTasks);

      // Act
      final result = await loadMoreTasksUseCase(limit: testLimit, offset: testOffset);

      // Assert
      expect(result, tTasks);
      verify(mockTaskRepository.getTasks(limit: testLimit, offset: testOffset));
      verifyNoMoreInteractions(mockTaskRepository);
    });

    test('should return an empty list if no more tasks are available', () async {
      // Arrange
      const testLimit = 10;
      const testOffset = 20;
      when(mockTaskRepository.getTasks(limit: testLimit, offset: testOffset))
          .thenAnswer((_) async => []);

      // Act
      final result = await loadMoreTasksUseCase(limit: testLimit, offset: testOffset);

      // Assert
      expect(result, []);
      verify(mockTaskRepository.getTasks(limit: testLimit, offset: testOffset));
      verifyNoMoreInteractions(mockTaskRepository);
    });
  });
}
