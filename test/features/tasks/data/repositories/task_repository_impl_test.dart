import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/features/tasks/data/repositories/task_repository_impl.dart';

import 'fake_storage_service.dart';

void main() {
  late TaskRepositoryImpl taskRepository;
  late FakeStorageService fakeStorageService;

  setUp(() {
    fakeStorageService = FakeStorageService();
    taskRepository = TaskRepositoryImpl(storageService: fakeStorageService);
  });

  final task1 = Task(id: '1', title: 'Task 1');
  final task2 = Task(id: '2', title: 'Task 2');
  final _ = [task1, task2];

  test('addTask should add a task to storage', () async {
    await taskRepository.addTask(task1);

    final tasksInStorage = await fakeStorageService.getTasks();
    expect(tasksInStorage.length, 1);
    expect(tasksInStorage.first['id'], task1.id);
  });

  test('deleteTask should remove a task from storage', () async {
    fakeStorageService.tasks = [task1.toJson(), task2.toJson()];

    await taskRepository.deleteTask('1');

    final tasksInStorage = await fakeStorageService.getTasks();
    expect(tasksInStorage.length, 1);
    expect(tasksInStorage.first['id'], task2.id);
  });

  test('getTasks should return a list of tasks from storage', () async {
    fakeStorageService.tasks = [task1.toJson(), task2.toJson()];

    final result = await taskRepository.getTasks();

    expect(result.length, 2);
    expect(result.first.id, task2.id); // The repository sorts by id desc
  });

  test('updateTask should update a task in storage', () async {
    final updatedTask = task1.copyWith(title: 'Updated Task 1');
    fakeStorageService.tasks = [task1.toJson(), task2.toJson()];

    await taskRepository.updateTask(updatedTask);

    final tasksInStorage = await fakeStorageService.getTasks();
    expect(tasksInStorage.length, 2);
    expect(tasksInStorage.first['title'], updatedTask.title);
  });

  test('deleteAllTasks should remove all tasks from storage', () async {
    fakeStorageService.tasks = [task1.toJson(), task2.toJson()];

    await taskRepository.deleteAllTasks();

    final tasksInStorage = await fakeStorageService.getTasks();
    expect(tasksInStorage.isEmpty, isTrue);
  });
}
