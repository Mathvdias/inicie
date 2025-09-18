import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/core/di/service_locator.dart';
import 'package:inicie/core/services/notification_service.dart';
import 'package:inicie/core/services/storage_service.dart';
import 'package:inicie/main.dart';
import 'package:inicie/l10n/app_localizations.dart';
import 'package:inicie/features/tasks/presentation/views/task_list_page.dart';
import 'package:inicie/features/tasks/presentation/viewmodels/i_task_viewmodel.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/services.dart';

import 'main_test.mocks.dart';

@GenerateMocks([StorageService, NotificationService])
void main() {
  late MockStorageService mockStorageService;
  late MockNotificationService mockNotificationService;
  late MockITaskViewModel mockTaskViewModel;

  setUp(() async {
    getIt.reset();
    getIt.allowReassignment = true;

    mockStorageService = MockStorageService();
    mockNotificationService = MockNotificationService();
    mockTaskViewModel = MockITaskViewModel();

    when(mockStorageService.init()).thenAnswer((_) async => {});
    when(mockNotificationService.init()).thenAnswer((_) async => {});
    when(
      mockNotificationService.requestPermissions(),
    ).thenAnswer((_) async => true);

    when(
      mockTaskViewModel.loadTasks(),
    ).thenAnswer((_) => Future.microtask(() => null));
    when(mockTaskViewModel.tasks).thenReturn([]);
    when(mockTaskViewModel.state).thenReturn(ViewState.idle);
    when(mockTaskViewModel.hasMoreTasks).thenReturn(false);
    when(mockTaskViewModel.errorMessage).thenReturn('');

    getIt.registerSingleton<StorageService>(mockStorageService);
    getIt.registerSingleton<NotificationService>(mockNotificationService);
    getIt.registerSingleton<ITaskViewModel>(mockTaskViewModel);
    getIt.registerSingleton<ValueNotifier<Locale>>(
      ValueNotifier(const Locale('en')),
    );

    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/shared_preferences'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'getAll') {
              return <String, dynamic>{}; // Return an empty map for getAll
            }
            return null;
          },
        );
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets('InicieApp displays TaskListPage and configures MaterialApp', (
    tester,
  ) async {
    await tester.pumpWidget(const InicieApp());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Inicie Tasks'), findsOneWidget);
    expect(find.byType(TaskListPage), findsOneWidget);

    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.title, 'Inicie Tasks');
    expect(app.debugShowCheckedModeBanner, false);
    expect(app.locale, const Locale('en'));
    expect(app.localizationsDelegates, AppLocalizations.localizationsDelegates);
    expect(app.supportedLocales, AppLocalizations.supportedLocales);
  });
}

class MockITaskViewModel extends Mock implements ITaskViewModel {
  @override
  Future<void> loadTasks() => super.noSuchMethod(
    Invocation.method(#loadTasks, []),
    returnValue: Future.value(null),
    returnValueForMissingStub: Future.value(null),
  );

  @override
  List<Task> get tasks => super.noSuchMethod(
    Invocation.getter(#tasks),
    returnValue: <Task>[],
    returnValueForMissingStub: <Task>[],
  );
  @override
  ViewState get state => super.noSuchMethod(
    Invocation.getter(#state),
    returnValue: ViewState.idle,
    returnValueForMissingStub: ViewState.idle,
  );
  @override
  bool get hasMoreTasks => super.noSuchMethod(
    Invocation.getter(#hasMoreTasks),
    returnValue: false,
    returnValueForMissingStub: false,
  );
  @override
  String get errorMessage => super.noSuchMethod(
    Invocation.getter(#errorMessage),
    returnValue: '',
    returnValueForMissingStub: '',
  );
}
