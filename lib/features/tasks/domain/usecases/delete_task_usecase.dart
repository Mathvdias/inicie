import 'package:inicie/core/services/notification_service.dart';
import 'package:inicie/features/tasks/domain/repositories/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository _taskRepository;
  final NotificationService _notificationService;

  DeleteTaskUseCase(this._taskRepository, this._notificationService);

  Future<void> call(String taskId) async {
    await _notificationService.cancelNotification(taskId);
    await _taskRepository.deleteTask(taskId);
  }
}
