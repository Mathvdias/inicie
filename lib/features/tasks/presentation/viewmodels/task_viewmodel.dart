import 'package:flutter/foundation.dart';
import 'package:inicie/core/services/notification_service.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/features/tasks/domain/repositories/task_repository.dart';
import 'package:inicie/utils/app_logger.dart';

enum ViewState { idle, loading, loadingMore, error }

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository;
  final NotificationService _notificationService;

  static const _kPageLimit = 20;

  TaskViewModel({
    required TaskRepository taskRepository,
    required NotificationService notificationService,
  }) : _taskRepository = taskRepository,
       _notificationService = notificationService;

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  bool _hasMoreTasks = true;
  bool get hasMoreTasks => _hasMoreTasks;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> loadTasks() async {
    try {
      _setState(ViewState.loading);
      _tasks = await _taskRepository.getTasks(limit: _kPageLimit, offset: 0);
      _hasMoreTasks = _tasks.length == _kPageLimit;
      _setState(ViewState.idle);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }

  Future<void> loadMoreTasks() async {
    if (_state == ViewState.loadingMore || !_hasMoreTasks) return;

    try {
      _setState(ViewState.loadingMore);
      final newTasks = await _taskRepository.getTasks(
        limit: _kPageLimit,
        offset: _tasks.length,
      );
      _tasks.addAll(newTasks);
      _hasMoreTasks = newTasks.length == _kPageLimit;
      _setState(ViewState.idle);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }

  Future<void> addTask(
    String title, {
    String? description,
    DateTime? reminderDateTime,
  }) async {
    logger.d("TaskViewModel: addTask called with reminderDateTime: $reminderDateTime");
    if (title.isEmpty) {
      _errorMessage = 'Title cannot be empty.';
      _setState(ViewState.error);
      return;
    }
    try {
      _setState(ViewState.loading);
      final newTask = Task(
        title: title,
        description: description,
        reminderDateTime: reminderDateTime,
      );
      await _taskRepository.addTask(newTask);
      if (newTask.reminderDateTime != null) {
        logger.d("TaskViewModel: Calling scheduleNotification for task ${newTask.id}");
        await _notificationService.scheduleNotification(newTask);
      }
      await loadTasks();
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }

  Future<void> updateTask(Task task) async {
    logger.d("TaskViewModel: updateTask called for task ${task.id} with reminderDateTime: ${task.reminderDateTime}");
    try {
      _setState(ViewState.loading);
      await _taskRepository.updateTask(task);
      if (task.reminderDateTime != null) {
        logger.d("TaskViewModel: Calling scheduleNotification for task ${task.id}");
        await _notificationService.scheduleNotification(task);
      } else {
        logger.d("TaskViewModel: Calling cancelNotification for task ${task.id}");
        await _notificationService.cancelNotification(task.id);
      }
      await loadTasks();
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    if (updatedTask.isCompleted) {
      await _notificationService.cancelNotification(task.id);
    }
    await updateTask(updatedTask);
  }

  Future<void> deleteTask(String taskId) async {
    try {
      _setState(ViewState.loading);
      await _notificationService.cancelNotification(taskId);
      await _taskRepository.deleteTask(taskId);
      await loadTasks();
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }

  Future<void> deleteAllTasks() async {
    try {
      _setState(ViewState.loading);
      for (final task in _tasks) {
        await _notificationService.cancelNotification(task.id);
      }
      await _taskRepository.deleteAllTasks();
      await loadTasks();
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }
}
