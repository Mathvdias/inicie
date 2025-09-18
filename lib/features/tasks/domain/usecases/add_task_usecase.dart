import 'package:inicie/core/services/notification_service.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/features/tasks/domain/repositories/task_repository.dart';
import 'package:inicie/utils/app_logger.dart';

class AddTaskUseCase {
  final TaskRepository _taskRepository;
  final NotificationService _notificationService;

  AddTaskUseCase(this._taskRepository, this._notificationService);

  Future<void> call({
    required String title,
    String? description,
    DateTime? reminderDateTime,
  }) async {
    logger.d("AddTaskUseCase: addTask called with reminderDateTime: $reminderDateTime");
    if (title.isEmpty) {
      throw Exception('Title cannot be empty.');
    }
    final newTask = Task(
      title: title,
      description: description,
      reminderDateTime: reminderDateTime,
    );
    await _taskRepository.addTask(newTask);
    if (newTask.reminderDateTime != null) {
      logger.d("AddTaskUseCase: Calling scheduleNotification for task ${newTask.id}");
      await _notificationService.scheduleNotification(newTask);
    }
  }
}
