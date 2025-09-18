import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/core/di/service_locator.dart';
import 'package:inicie/core/services/notification_service.dart';
import 'package:inicie/core/services/storage_service.dart';
import 'package:inicie/features/tasks/domain/repositories/task_repository.dart';
import 'package:inicie/features/tasks/presentation/viewmodels/i_task_viewmodel.dart';
import 'package:inicie/features/tasks/domain/usecases/add_task_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/delete_all_tasks_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/load_more_tasks_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/toggle_task_completion_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/update_task_usecase.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    getIt.reset(); // Reset GetIt before each test
    setupLocator(); // Call setupLocator after reset
  });

  test('Service locator setup registers all dependencies', () {
    // Verify that all services are registered
    expect(getIt.isRegistered<StorageService>(), isTrue);
    expect(getIt.isRegistered<NotificationService>(), isTrue);
    expect(getIt.isRegistered<TaskRepository>(), isTrue);
    expect(getIt.isRegistered<ITaskViewModel>(), isTrue);
    expect(getIt.isRegistered<GetTasksUseCase>(), isTrue);
    expect(getIt.isRegistered<LoadMoreTasksUseCase>(), isTrue);
    expect(getIt.isRegistered<AddTaskUseCase>(), isTrue);
    expect(getIt.isRegistered<UpdateTaskUseCase>(), isTrue);
    expect(getIt.isRegistered<ToggleTaskCompletionUseCase>(), isTrue);
    expect(getIt.isRegistered<DeleteTaskUseCase>(), isTrue);
    expect(getIt.isRegistered<DeleteAllTasksUseCase>(), isTrue);

    // Verify that instances can be retrieved
    expect(getIt<StorageService>(), isA<StorageService>());
    expect(getIt<NotificationService>(), isA<NotificationService>());
    expect(getIt<TaskRepository>(), isA<TaskRepository>());
    expect(getIt<ITaskViewModel>(), isA<ITaskViewModel>());
    expect(getIt<GetTasksUseCase>(), isA<GetTasksUseCase>());
    expect(getIt<LoadMoreTasksUseCase>(), isA<LoadMoreTasksUseCase>());
    expect(getIt<AddTaskUseCase>(), isA<AddTaskUseCase>());
    expect(getIt<UpdateTaskUseCase>(), isA<UpdateTaskUseCase>());
    expect(getIt<ToggleTaskCompletionUseCase>(), isA<ToggleTaskCompletionUseCase>());
    expect(getIt<DeleteTaskUseCase>(), isA<DeleteTaskUseCase>());
    expect(getIt<DeleteAllTasksUseCase>(), isA<DeleteAllTasksUseCase>());
  });
}