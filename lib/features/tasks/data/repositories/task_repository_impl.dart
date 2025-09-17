import 'package:inicie/core/services/storage_service.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final StorageService storageService;

  TaskRepositoryImpl({required this.storageService}) {
    storageService.init();
  }

  @override
  Future<void> addTask(Task task) async {
    final tasks = await _getAllTasks();
    tasks.add(task);
    await _saveTasks(tasks);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final tasks = await _getAllTasks();
    tasks.removeWhere((task) => task.id == taskId);
    await _saveTasks(tasks);
  }

  @override
  Future<List<Task>> getTasks({int limit = 20, int offset = 0}) async {
    final tasks = await _getAllTasks();
    tasks.sort((a, b) => b.id.compareTo(a.id));
    return tasks.skip(offset).take(limit).toList();
  }

  @override
  Future<void> updateTask(Task task) async {
    final tasks = await _getAllTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await _saveTasks(tasks);
    }
  }

  @override
  Future<void> deleteAllTasks() async {
    await _saveTasks([]);
  }

  Future<List<Task>> _getAllTasks() async {
    final taskMaps = await storageService.getTasks();
    return taskMaps.map((map) => Task.fromJson(map)).toList();
  }

  Future<void> _saveTasks(List<Task> tasks) async {
    final taskMaps = tasks.map((task) => task.toJson()).toList();
    await storageService.saveTasks(taskMaps);
  }
}
