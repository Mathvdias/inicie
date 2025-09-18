import 'package:inicie/core/services/notification_service.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/features/tasks/domain/repositories/task_repository.dart';

class ToggleTaskCompletionUseCase {
  final TaskRepository _taskRepository;
  final NotificationService _notificationService;

  ToggleTaskCompletionUseCase(this._taskRepository, this._notificationService);

  Future<void> call(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    if (updatedTask.isCompleted) {
      await _notificationService.cancelNotification(task.id);
    }
    await _taskRepository.updateTask(updatedTask);
  }
}
