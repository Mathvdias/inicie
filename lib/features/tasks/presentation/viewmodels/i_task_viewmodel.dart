import 'package:flutter/foundation.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';

enum ViewState { idle, loading, loadingMore, error }

abstract class ITaskViewModel extends ChangeNotifier {
  List<Task> get tasks;
  ViewState get state;
  bool get hasMoreTasks;
  String get errorMessage;

  Future<void> loadTasks();
  Future<void> loadMoreTasks();
  Future<void> addTask({
    required String title,
    String? description,
    DateTime? reminderDateTime,
  });
  Future<void> updateTask(Task task);
  Future<void> toggleTaskCompletion(Task task);
  Future<void> deleteTask(String taskId);
  Future<void> deleteAllTasks();
}
