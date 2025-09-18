import 'package:inicie/core/services/notification_service.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/features/tasks/domain/repositories/task_repository.dart';

class DeleteAllTasksUseCase {
  final TaskRepository _taskRepository;
  final NotificationService _notificationService;

  DeleteAllTasksUseCase(this._taskRepository, this._notificationService);

  Future<void> call(List<Task> tasks) async {
    for (final task in tasks) {
      await _notificationService.cancelNotification(task.id);
    }
    await _taskRepository.deleteAllTasks();
  }
}
