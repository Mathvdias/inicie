import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/core/di/service_locator.dart';
import 'package:inicie/core/services/notification_service.dart';
import 'package:inicie/core/services/storage_service.dart';
import 'package:inicie/features/tasks/domain/repositories/task_repository.dart';
import 'package:inicie/features/tasks/presentation/viewmodels/task_viewmodel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    getIt.reset(); // Reset GetIt before each test
  });

  test('Service locator setup registers all dependencies', () {
    setupLocator();

    // Verify that all services are registered
    expect(getIt.isRegistered<StorageService>(), isTrue);
    expect(getIt.isRegistered<NotificationService>(), isTrue);
    expect(
      getIt.isRegistered<TaskRepository>(),
      isTrue,
    ); // TaskRepository is the abstract type
    expect(getIt.isRegistered<TaskViewModel>(), isTrue);

    // Verify that instances can be retrieved
    expect(getIt<StorageService>(), isA<StorageService>());
    expect(getIt<NotificationService>(), isA<NotificationService>());
    expect(
      getIt<TaskRepository>(),
      isA<TaskRepository>(),
    ); // Expect TaskRepository
    expect(getIt<TaskViewModel>(), isA<TaskViewModel>());
  });
}
