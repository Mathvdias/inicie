import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/features/tasks/domain/repositories/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository _taskRepository;

  GetTasksUseCase(this._taskRepository);

  Future<List<Task>> call({int limit = 20, int offset = 0}) async {
    return await _taskRepository.getTasks(limit: limit, offset: offset);
  }
}
