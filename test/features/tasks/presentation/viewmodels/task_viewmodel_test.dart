import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/core/services/notification_service.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/features/tasks/domain/repositories/task_repository.dart';
import 'package:inicie/features/tasks/presentation/viewmodels/task_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'task_viewmodel_test.mocks.dart';

@GenerateMocks([TaskRepository, NotificationService])
void main() {
  late TaskViewModel viewModel;
  late MockTaskRepository mockTaskRepository;
  late MockNotificationService mockNotificationService;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    mockNotificationService = MockNotificationService();
    viewModel = TaskViewModel(
      taskRepository: mockTaskRepository,
      notificationService: mockNotificationService,
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
      test('should get tasks from repository and update state', () async {
        when(
          mockTaskRepository.getTasks(limit: 20, offset: 0),
        ).thenAnswer((_) async => tTasks);

        await viewModel.loadTasks();

        expect(viewModel.tasks, tTasks);
        expect(viewModel.state, ViewState.idle);
        verify(mockTaskRepository.getTasks(limit: 20, offset: 0));
      });

      test(
        'should set hasMoreTasks to false when fewer tasks than limit are returned',
        () async {
          when(
            mockTaskRepository.getTasks(limit: 20, offset: 0),
          ).thenAnswer((_) async => [tTask1]);

          await viewModel.loadTasks();

          expect(viewModel.hasMoreTasks, isFalse);
        },
      );

      test('should set state to error on exception', () async {
        when(
          mockTaskRepository.getTasks(limit: 20, offset: 0),
        ).thenThrow(Exception('Error'));

        await viewModel.loadTasks();

        expect(viewModel.state, ViewState.error);
        expect(viewModel.errorMessage, 'Exception: Error');
      });
    });

    group('loadMoreTasks', () {
      test('should fetch more tasks and add them to the list', () async {
        // Setup initial state
        when(mockTaskRepository.getTasks(limit: 20, offset: 0)).thenAnswer(
          (_) async => List.generate(
            20,
            (index) => Task(id: '$index', title: 'Task $index'),
          ),
        ); // Simulate 20 tasks to keep hasMoreTasks true
        await viewModel.loadTasks(); // Load initial tasks

        final moreTasks = [Task(id: '3', title: 'Task 3')];
        when(
              mockTaskRepository.getTasks(limit: 20, offset: 20),
            ) // Offset should be 20 now
            .thenAnswer((_) async => moreTasks);

        await viewModel.loadMoreTasks();

        expect(viewModel.tasks.length, 21); // 20 initial + 1 more task
        expect(viewModel.state, ViewState.idle);
        verify(mockTaskRepository.getTasks(limit: 20, offset: 20));
      });

      test('should not fetch more if already loading more', () async {
        // Arrange
        // Simulate initial load to have some tasks and set hasMoreTasks
        when(
          mockTaskRepository.getTasks(limit: 20, offset: 0),
        ).thenAnswer((_) async => [tTask1, tTask2]);
        await viewModel.loadTasks();

        // Simulate loadingMore state by making the next getTasks call never complete
        when(mockTaskRepository.getTasks(limit: 20, offset: 2)).thenAnswer(
          (_) => Future.delayed(const Duration(days: 1)),
        ); // Simulate an ongoing load

        // Act
        // Call loadMoreTasks, which should immediately return because state is loadingMore
        viewModel
            .loadMoreTasks(); // Don't await, as it's simulating a long-running operation

        // Assert
        // Verify that getTasks was not called again immediately for the second loadMoreTasks call
        verify(
          mockTaskRepository.getTasks(limit: 20, offset: 0),
        ).called(1); // Only the initial call
        verifyNoMoreInteractions(mockTaskRepository);
      });

      test('should not fetch more if hasMoreTasks is false', () async {
        // Arrange
        when(mockTaskRepository.getTasks(limit: 20, offset: 0)).thenAnswer(
          (_) async => [tTask1],
        ); // Only 1 task, so hasMoreTasks will be false
        await viewModel.loadTasks();
        expect(viewModel.hasMoreTasks, isFalse);

        // Act
        await viewModel.loadMoreTasks();

        // Assert
        verify(
          mockTaskRepository.getTasks(limit: 20, offset: 0),
        ).called(1); // Only the initial call
        verifyNoMoreInteractions(mockTaskRepository);
      });
    });

    group('addTask', () {
      test('should not add task if title is empty', () async {
        await viewModel.addTask('');

        expect(viewModel.state, ViewState.error);
        expect(viewModel.errorMessage, 'Title cannot be empty.');
        verifyZeroInteractions(mockTaskRepository);
      });

      test('should add task and schedule notification', () async {
        final reminder = DateTime.now();
        when(mockTaskRepository.addTask(any)).thenAnswer((_) async {});
        when(
          mockTaskRepository.getTasks(limit: 20, offset: 0),
        ).thenAnswer((_) async => []);
        when(
          mockNotificationService.scheduleNotification(any),
        ).thenAnswer((_) async {});

        await viewModel.addTask('New', reminderDateTime: reminder);

        final captured =
            verify(mockTaskRepository.addTask(captureAny)).captured.single
                as Task;
        expect(captured.title, 'New');
        expect(captured.reminderDateTime, reminder);
        verify(mockNotificationService.scheduleNotification(captured));
      });
    });

    group('updateTask', () {
      test('should update task and reschedule notification', () async {
        final updatedTask = tTask1.copyWith(reminderDateTime: DateTime.now());
        when(mockTaskRepository.updateTask(any)).thenAnswer((_) async {});
        when(
          mockTaskRepository.getTasks(limit: 20, offset: 0),
        ).thenAnswer((_) async => []);
        when(
          mockNotificationService.scheduleNotification(any),
        ).thenAnswer((_) async {});

        await viewModel.updateTask(updatedTask);

        verify(mockTaskRepository.updateTask(updatedTask));
        verify(mockNotificationService.scheduleNotification(updatedTask));
      });

      test(
        'should update task and cancel notification if reminder is removed',
        () async {
          final updatedTask = tTask1.copyWith(reminderDateTime: null);
          when(mockTaskRepository.updateTask(any)).thenAnswer((_) async {});
          when(
            mockTaskRepository.getTasks(limit: 20, offset: 0),
          ).thenAnswer((_) async => []);
          when(
            mockNotificationService.cancelNotification(any),
          ).thenAnswer((_) async {});

          await viewModel.updateTask(updatedTask);

          verify(mockTaskRepository.updateTask(updatedTask));
          verify(mockNotificationService.cancelNotification(updatedTask.id));
        },
      );

      test(
        'should update task and cancel notification if task is completed',
        () async {
          final updatedTask = tTask1.copyWith(isCompleted: true);
          when(mockTaskRepository.updateTask(any)).thenAnswer((_) async {});
          when(
            mockTaskRepository.getTasks(limit: 20, offset: 0),
          ).thenAnswer((_) async => []);
          when(
            mockNotificationService.cancelNotification(any),
          ).thenAnswer((_) async {});

          await viewModel.updateTask(updatedTask);

          verify(mockTaskRepository.updateTask(updatedTask));
          verify(mockNotificationService.cancelNotification(updatedTask.id));
        },
      );
    });

    group('toggleTaskCompletion', () {
      test('should cancel notification if task is completed', () async {
        when(mockTaskRepository.updateTask(any)).thenAnswer((_) async {});
        when(
          mockTaskRepository.getTasks(limit: 20, offset: 0),
        ).thenAnswer((_) async => []);
        when(
          mockNotificationService.cancelNotification(any),
        ).thenAnswer((_) async {});

        await viewModel.toggleTaskCompletion(tTask1);

        final captured =
            verify(mockTaskRepository.updateTask(captureAny)).captured.single
                as Task;
        expect(captured.isCompleted, isTrue);
        verify(mockNotificationService.cancelNotification(tTask1.id));
      });
    });

    group('deleteTask', () {
      test('should delete task and cancel notification', () async {
        when(mockTaskRepository.deleteTask(any)).thenAnswer((_) async {});
        when(
          mockTaskRepository.getTasks(limit: 20, offset: 0),
        ).thenAnswer((_) async => []);
        when(
          mockNotificationService.cancelNotification(any),
        ).thenAnswer((_) async {});

        await viewModel.deleteTask(tTask1.id);

        verify(mockTaskRepository.deleteTask(tTask1.id));
        verify(mockNotificationService.cancelNotification(tTask1.id));
      });
    });

    group('deleteAllTasks', () {
      test('should delete all tasks and cancel all notifications', () async {
        // Simulate tasks being in the view model
        viewModel.tasks.addAll(tTasks);
        when(mockTaskRepository.deleteAllTasks()).thenAnswer((_) async {});
        when(
          mockTaskRepository.getTasks(limit: 20, offset: 0),
        ).thenAnswer((_) async => []);
        when(
          mockNotificationService.cancelNotification(any),
        ).thenAnswer((_) async {});

        await viewModel.deleteAllTasks();

        verify(mockTaskRepository.deleteAllTasks());
        verify(mockNotificationService.cancelNotification(tTask1.id));
        verify(mockNotificationService.cancelNotification(tTask2.id));
      });
    });
  });
}
