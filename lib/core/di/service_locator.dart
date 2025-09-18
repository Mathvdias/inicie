import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:inicie/core/services/notification_service.dart';
import 'package:inicie/core/services/storage_service.dart';
import 'package:inicie/core/services/timezone_service.dart';
import 'package:inicie/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:inicie/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:inicie/features/tasks/domain/repositories/task_repository.dart';
import 'package:inicie/features/tasks/domain/usecases/add_task_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/delete_all_tasks_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/load_more_tasks_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/toggle_task_completion_usecase.dart';
import 'package:inicie/features/tasks/domain/usecases/update_task_usecase.dart';
import 'package:inicie/features/tasks/presentation/viewmodels/i_task_viewmodel.dart';
import 'package:inicie/features/tasks/presentation/viewmodels/task_viewmodel.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Services
  getIt.registerLazySingleton<StorageService>(
    () => SharedPreferencesStorageService(),
  );
  getIt.registerLazySingleton<TimezoneService>(() => FlutterTimezoneService());
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService(
      notificationsPlugin: FlutterLocalNotificationsPlugin(),
      timezoneService: getIt<TimezoneService>(),
    ),
  );

  getIt.registerLazySingleton<ValueNotifier<Locale>>(
    () => ValueNotifier<Locale>(const Locale('en')),
  );

  // Repositories
  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(storageService: getIt<StorageService>()),
  );

  // Use Cases
  getIt.registerLazySingleton<GetTasksUseCase>(
    () => GetTasksUseCase(getIt<TaskRepository>()),
  );
  getIt.registerLazySingleton<LoadMoreTasksUseCase>(
    () => LoadMoreTasksUseCase(getIt<TaskRepository>()),
  );
  getIt.registerLazySingleton<AddTaskUseCase>(
    () => AddTaskUseCase(getIt<TaskRepository>(), getIt<NotificationService>()),
  );
  getIt.registerLazySingleton<UpdateTaskUseCase>(
    () => UpdateTaskUseCase(getIt<TaskRepository>(), getIt<NotificationService>()),
  );
  getIt.registerLazySingleton<ToggleTaskCompletionUseCase>(
    () => ToggleTaskCompletionUseCase(getIt<TaskRepository>(), getIt<NotificationService>()),
  );
  getIt.registerLazySingleton<DeleteTaskUseCase>(
    () => DeleteTaskUseCase(getIt<TaskRepository>(), getIt<NotificationService>()),
  );
  getIt.registerLazySingleton<DeleteAllTasksUseCase>(
    () => DeleteAllTasksUseCase(getIt<TaskRepository>(), getIt<NotificationService>()),
  );

  // ViewModels
  getIt.registerFactory<ITaskViewModel>(
    () => TaskViewModel(
      getTasksUseCase: getIt<GetTasksUseCase>(),
      loadMoreTasksUseCase: getIt<LoadMoreTasksUseCase>(),
      addTaskUseCase: getIt<AddTaskUseCase>(),
      updateTaskUseCase: getIt<UpdateTaskUseCase>(),
      toggleTaskCompletionUseCase: getIt<ToggleTaskCompletionUseCase>(),
      deleteTaskUseCase: getIt<DeleteTaskUseCase>(),
      deleteAllTasksUseCase: getIt<DeleteAllTasksUseCase>(),
    ),
  );
}