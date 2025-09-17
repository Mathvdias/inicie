import 'package:inicie/features/tasks/data/models/task_model.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks({int limit, int offset});
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
  Future<void> deleteAllTasks();
}
