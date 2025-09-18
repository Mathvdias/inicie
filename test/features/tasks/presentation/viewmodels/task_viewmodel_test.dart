import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/features/tasks/domain/usecases/add_task_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/delete_all_tasks_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/load_more_tasks_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/toggle_task_completion_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/update_task_usecase.dart';
import 'package:inicie/features/tasks/presentation/viewmodels/task_viewmodel.dart';
import 'package:inicie/features/tasks/presentation/viewmodels/i_task_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'task_viewmodel_test.mocks.dart';

@GenerateMocks([
  GetTasksUseCase,
  LoadMoreTasksUseCase,
  AddTaskUseCase,
  UpdateTaskUseCase,
  ToggleTaskCompletionUseCase,
  DeleteTaskUseCase,
  DeleteAllTasksUseCase,
])
void main() {
  late TaskViewModel viewModel;
  late MockGetTasksUseCase mockGetTasksUseCase;
  late MockLoadMoreTasksUseCase mockLoadMoreTasksUseCase;
  late MockAddTaskUseCase mockAddTaskUseCase;
  late MockUpdateTaskUseCase mockUpdateTaskUseCase;
  late MockToggleTaskCompletionUseCase mockToggleTaskCompletionUseCase;
  late MockDeleteTaskUseCase mockDeleteTaskUseCase;
  late MockDeleteAllTasksUseCase mockDeleteAllTasksUseCase;

  setUp(() {
    mockGetTasksUseCase = MockGetTasksUseCase();
    mockLoadMoreTasksUseCase = MockLoadMoreTasksUseCase();
    mockAddTaskUseCase = MockAddTaskUseCase();
    mockUpdateTaskUseCase = MockUpdateTaskUseCase();
    mockToggleTaskCompletionUseCase = MockToggleTaskCompletionUseCase();
    mockDeleteTaskUseCase = MockDeleteTaskUseCase();
    mockDeleteAllTasksUseCase = MockDeleteAllTasksUseCase();

    viewModel = TaskViewModel(
      getTasksUseCase: mockGetTasksUseCase,
      loadMoreTasksUseCase: mockLoadMoreTasksUseCase,
      addTaskUseCase: mockAddTaskUseCase,
      updateTaskUseCase: mockUpdateTaskUseCase,
      toggleTaskCompletionUseCase: mockToggleTaskCompletionUseCase,
      deleteTaskUseCase: mockDeleteTaskUseCase,
      deleteAllTasksUseCase: mockDeleteAllTasksUseCase,
    );
  });

  group('TaskViewModel', () {
    final tTask1 = Task(id: '1', title: 'Task 1');
    final tTask2 = Task(id: '2', title: 'Task 2');
    final tTasks = [tTask1, tTask2];

    test('Initial state is correct', () {
      expect(viewModel.state, ViewState.idle);
      expect(viewModel.tasks, isEmpty);
      expect(viewModel.hasMoreTasks, true);
    });

    group('loadTasks', () {
      test('should get tasks from use case and update state', () async {
        when(
          mockGetTasksUseCase(limit: 20, offset: 0),
        ).thenAnswer((_) async => tTasks);

        await viewModel.loadTasks();

        expect(viewModel.tasks, tTasks);
        expect(viewModel.state, ViewState.idle);
        verify(mockGetTasksUseCase(limit: 20, offset: 0));
        verifyNoMoreInteractions(mockGetTasksUseCase);
      });

      test(
        'should set hasMoreTasks to false when fewer tasks than limit are returned',
        () async {
          when(
            mockGetTasksUseCase(limit: 20, offset: 0),
          ).thenAnswer((_) async => [tTask1]);

          await viewModel.loadTasks();

          expect(viewModel.hasMoreTasks, isFalse);
          verify(mockGetTasksUseCase(limit: 20, offset: 0));
          verifyNoMoreInteractions(mockGetTasksUseCase);
        },
      );

      test('should set state to error on exception', () async {
        when(
          mockGetTasksUseCase(limit: 20, offset: 0),
        ).thenThrow(Exception('Error'));

        await viewModel.loadTasks();

        expect(viewModel.state, ViewState.error);
        expect(viewModel.errorMessage, 'Exception: Error');
        verify(mockGetTasksUseCase(limit: 20, offset: 0));
        verifyNoMoreInteractions(mockGetTasksUseCase);
      });
    });

    group('loadMoreTasks', () {
      test(
        'should fetch more tasks from use case and add them to the list',
        () async {
          // Setup initial state
          when(mockGetTasksUseCase(limit: 20, offset: 0)).thenAnswer(
            (_) async => List.generate(
              20,
              (index) => Task(id: '$index', title: 'Task $index'),
            ),
          );
          await viewModel.loadTasks();

          final moreTasks = [Task(id: '3', title: 'Task 3')];
          when(
            mockLoadMoreTasksUseCase(limit: 20, offset: 20),
          ).thenAnswer((_) async => moreTasks);

          await viewModel.loadMoreTasks();

          expect(viewModel.tasks.length, 21);
          expect(viewModel.state, ViewState.idle);
          verify(mockLoadMoreTasksUseCase(limit: 20, offset: 20));
          verifyNoMoreInteractions(mockLoadMoreTasksUseCase);
        },
      );

      test('should not fetch more if already loading more', () async {
        // Arrange
        when(
          mockGetTasksUseCase(limit: 20, offset: 0),
        ).thenAnswer((_) async => [tTask1, tTask2]);
        await viewModel.loadTasks();

        when(
          mockLoadMoreTasksUseCase(limit: 20, offset: 2),
        ).thenAnswer((_) => Future.delayed(const Duration(days: 1)));

        viewModel.loadMoreTasks();

        verifyNever(mockLoadMoreTasksUseCase(limit: 20, offset: 2));
      });

      test('should not fetch more if hasMoreTasks is false', () async {
        // Arrange
        when(
          mockGetTasksUseCase(limit: 20, offset: 0),
        ).thenAnswer((_) async => [tTask1]);
        await viewModel.loadTasks();
        expect(viewModel.hasMoreTasks, isFalse);

        // Act
        await viewModel.loadMoreTasks();

        // Assert
        verifyZeroInteractions(mockLoadMoreTasksUseCase);
      });
    });

    group('addTask', () {
      test('should not add task if title is empty', () async {
        await viewModel.addTask(title: '');

        expect(viewModel.state, ViewState.error);
        expect(viewModel.errorMessage, 'Title cannot be empty.');
        verifyZeroInteractions(mockAddTaskUseCase);
      });

      test('should add task via use case and reload tasks', () async {
        final reminder = DateTime.now();
        when(
          mockAddTaskUseCase(
            title: anyNamed('title'),
            description: anyNamed('description'),
            reminderDateTime: anyNamed('reminderDateTime'),
          ),
        ).thenAnswer((_) async => Future.value());
        when(
          mockGetTasksUseCase(limit: 20, offset: 0),
        ).thenAnswer((_) async => []);

        await viewModel.addTask(title: 'New', reminderDateTime: reminder);

        verify(
          mockAddTaskUseCase(
            title: 'New',
            description: null,
            reminderDateTime: reminder,
          ),
        );
        verify(mockGetTasksUseCase(limit: 20, offset: 0));
        verifyNoMoreInteractions(mockAddTaskUseCase);
        verifyNoMoreInteractions(mockGetTasksUseCase);
      });
    });

    group('updateTask', () {
      test('should update task via use case and reload tasks', () async {
        final updatedTask = tTask1.copyWith(reminderDateTime: DateTime.now());
        when(
          mockUpdateTaskUseCase(any),
        ).thenAnswer((_) async => Future.value());
        when(
          mockGetTasksUseCase(limit: 20, offset: 0),
        ).thenAnswer((_) async => []);

        await viewModel.updateTask(updatedTask);

        verify(mockUpdateTaskUseCase(updatedTask));
        verify(mockGetTasksUseCase(limit: 20, offset: 0));
        verifyNoMoreInteractions(mockUpdateTaskUseCase);
        verifyNoMoreInteractions(mockGetTasksUseCase);
      });
    });

    group('toggleTaskCompletion', () {
      test(
        'should toggle task completion via use case and reload tasks',
        () async {
          when(
            mockToggleTaskCompletionUseCase(any),
          ).thenAnswer((_) async => Future.value());
          when(
            mockGetTasksUseCase(limit: 20, offset: 0),
          ).thenAnswer((_) async => []);

          await viewModel.toggleTaskCompletion(tTask1);

          verify(mockToggleTaskCompletionUseCase(tTask1));
          verify(mockGetTasksUseCase(limit: 20, offset: 0));
          verifyNoMoreInteractions(mockToggleTaskCompletionUseCase);
          verifyNoMoreInteractions(mockGetTasksUseCase);
        },
      );
    });

    group('deleteTask', () {
      test('should delete task via use case and reload tasks', () async {
        when(
          mockDeleteTaskUseCase(any),
        ).thenAnswer((_) async => Future.value());
        when(
          mockGetTasksUseCase(limit: 20, offset: 0),
        ).thenAnswer((_) async => []);

        await viewModel.deleteTask(tTask1.id);

        verify(mockDeleteTaskUseCase(tTask1.id));
        verify(mockGetTasksUseCase(limit: 20, offset: 0));
        verifyNoMoreInteractions(mockDeleteTaskUseCase);
        verifyNoMoreInteractions(mockGetTasksUseCase);
      });
    });

    group('deleteAllTasks', () {
      test('should delete all tasks via use case and reload tasks', () async {
        // Simulate tasks being in the view model
        viewModel.tasks.addAll(tTasks);
        when(
          mockDeleteAllTasksUseCase(any),
        ).thenAnswer((_) async => Future.value());
        when(
          mockGetTasksUseCase(limit: 20, offset: 0),
        ).thenAnswer((_) async => []);

        await viewModel.deleteAllTasks();

        verify(mockDeleteAllTasksUseCase(tTasks));
        verify(mockGetTasksUseCase(limit: 20, offset: 0));
        verifyNoMoreInteractions(mockDeleteAllTasksUseCase);
        verifyNoMoreInteractions(mockGetTasksUseCase);
      });
    });
  });
}
