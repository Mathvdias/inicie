import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:inicie/core/services/notification_service.dart';
import 'package:inicie/core/services/storage_service.dart';
import 'package:inicie/core/services/timezone_service.dart';
import 'package:inicie/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:inicie/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:inicie/features/tasks/domain/repositories/task_repository.dart';
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

  // Repositories
  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(storageService: getIt<StorageService>()),
  );

  // ViewModels
  getIt.registerFactory<TaskViewModel>(
    () => TaskViewModel(
      taskRepository: getIt<TaskRepository>(),
      notificationService: getIt<NotificationService>(),
    ),
  );
}
