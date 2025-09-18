import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/features/tasks/domain/usecases/add_task_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/delete_all_tasks_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/load_more_tasks_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/toggle_task_completion_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/update_task_usecase.dart';
import 'package:inicie/features/tasks/presentation/viewmodels/i_task_viewmodel.dart';

class TaskViewModel extends ITaskViewModel {
  final GetTasksUseCase _getTasksUseCase;
  final LoadMoreTasksUseCase _loadMoreTasksUseCase;
  final AddTaskUseCase _addTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final ToggleTaskCompletionUseCase _toggleTaskCompletionUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final DeleteAllTasksUseCase _deleteAllTasksUseCase;

  static const _kPageLimit = 20;

  TaskViewModel({
    required GetTasksUseCase getTasksUseCase,
    required LoadMoreTasksUseCase loadMoreTasksUseCase,
    required AddTaskUseCase addTaskUseCase,
    required UpdateTaskUseCase updateTaskUseCase,
    required ToggleTaskCompletionUseCase toggleTaskCompletionUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
    required DeleteAllTasksUseCase deleteAllTasksUseCase,
  }) : _getTasksUseCase = getTasksUseCase,
       _loadMoreTasksUseCase = loadMoreTasksUseCase,
       _addTaskUseCase = addTaskUseCase,
       _updateTaskUseCase = updateTaskUseCase,
       _toggleTaskCompletionUseCase = toggleTaskCompletionUseCase,
       _deleteTaskUseCase = deleteTaskUseCase,
       _deleteAllTasksUseCase = deleteAllTasksUseCase;

  List<Task> _tasks = [];
  @override
  List<Task> get tasks => _tasks;

  ViewState _state = ViewState.idle;
  @override
  ViewState get state => _state;

  bool _hasMoreTasks = true;
  @override
  bool get hasMoreTasks => _hasMoreTasks;

  String _errorMessage = '';
  @override
  String get errorMessage => _errorMessage;

  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  Future<void> loadTasks() async {
    try {
      _setState(ViewState.loading);
      _tasks = await _getTasksUseCase(limit: _kPageLimit, offset: 0);
      _hasMoreTasks = _tasks.length == _kPageLimit;
      _setState(ViewState.idle);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }

  @override
  Future<void> loadMoreTasks() async {
    if (_state == ViewState.loadingMore || !_hasMoreTasks) return;

    try {
      _setState(ViewState.loadingMore);
      final newTasks = await _loadMoreTasksUseCase(
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

  @override
  Future<void> addTask({
    required String title,
    String? description,
    DateTime? reminderDateTime,
  }) async {
    if (title.isEmpty) {
      _errorMessage = 'Title cannot be empty.';
      _setState(ViewState.error);
      return;
    }
    try {
      _setState(ViewState.loading);
      await _addTaskUseCase(
        title: title,
        description: description,
        reminderDateTime: reminderDateTime,
      );
      await loadTasks();
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    try {
      _setState(ViewState.loading);
      await _updateTaskUseCase(task);
      await loadTasks();
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }

  @override
  Future<void> toggleTaskCompletion(Task task) async {
    try {
      _setState(ViewState.loading);
      await _toggleTaskCompletionUseCase(task);
      await loadTasks();
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      _setState(ViewState.loading);
      await _deleteTaskUseCase(taskId);
      await loadTasks();
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }

  @override
  Future<void> deleteAllTasks() async {
    try {
      _setState(ViewState.loading);
      await _deleteAllTasksUseCase(_tasks);
      await loadTasks();
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }
}
