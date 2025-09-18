import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/features/tasks/domain/repositories/task_repository.dart';

class LoadMoreTasksUseCase {
  final TaskRepository _taskRepository;

  LoadMoreTasksUseCase(this._taskRepository);

  Future<List<Task>> call({required int limit, required int offset}) async {
    return await _taskRepository.getTasks(limit: limit, offset: offset);
  }
}
