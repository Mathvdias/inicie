import 'package:inicie/core/services/notification_service.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/features/tasks/domain/repositories/task_repository.dart';
import 'package:inicie/utils/app_logger.dart';

class UpdateTaskUseCase {
  final TaskRepository _taskRepository;
  final NotificationService _notificationService;

  UpdateTaskUseCase(this._taskRepository, this._notificationService);

  Future<void> call(Task task) async {
    logger.d("UpdateTaskUseCase: updateTask called for task ${task.id} with reminderDateTime: ${task.reminderDateTime}");
    await _taskRepository.updateTask(task);
    if (task.reminderDateTime != null) {
      logger.d("UpdateTaskUseCase: Calling scheduleNotification for task ${task.id}");
      await _notificationService.scheduleNotification(task);
    } else {
      logger.d("UpdateTaskUseCase: Calling cancelNotification for task ${task.id}");
      await _notificationService.cancelNotification(task.id);
    }
  }
}
