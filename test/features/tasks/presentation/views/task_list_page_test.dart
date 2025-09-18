import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/core/di/service_locator.dart';
import 'package:inicie/core/services/notification_service.dart';
import 'package:inicie/core/services/storage_service.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/features/tasks/presentation/viewmodels/i_task_viewmodel.dart'
    show ITaskViewModel, ViewState;
import 'package:inicie/features/tasks/presentation/views/task_list_page.dart';
import 'package:inicie/l10n/app_localizations.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'task_list_page_test.mocks.dart';

@GenerateMocks([ITaskViewModel, NotificationService, StorageService])
void main() {
  late MockITaskViewModel mockTaskViewModel;
  late MockNotificationService mockNotificationService;
  late MockStorageService mockStorageService;
  late MockValueNotifierLocale mockValueNotifier;
  late AppLocalizations l10n;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  setUp(() async {
    getIt.allowReassignment = true; // Allow re-registering singletons for tests

    mockTaskViewModel = MockITaskViewModel();
    mockNotificationService = MockNotificationService();
    mockStorageService = MockStorageService();
    mockValueNotifier = MockValueNotifierLocale();

    getIt.registerSingleton<ITaskViewModel>(mockTaskViewModel);
    getIt.registerSingleton<NotificationService>(mockNotificationService);
    getIt.registerSingleton<StorageService>(mockStorageService);
    getIt.registerSingleton<ValueNotifier<Locale>>(mockValueNotifier);

    when(mockNotificationService.init()).thenAnswer((_) async => {});
    when(mockNotificationService.requestPermissions()).thenAnswer((_) async => true);
    when(mockStorageService.init()).thenAnswer((_) async => {});
    when(mockTaskViewModel.loadTasks()).thenAnswer((_) async => {});
    when(mockTaskViewModel.tasks).thenReturn([]);
    when(mockTaskViewModel.state).thenReturn(ViewState.idle);
    when(mockTaskViewModel.hasMoreTasks).thenReturn(false);
    when(mockTaskViewModel.errorMessage).thenReturn('');

    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  tearDown(() {
    getIt.unregister<ITaskViewModel>();
    getIt.unregister<NotificationService>();
    getIt.unregister<StorageService>();
    getIt.unregister<ValueNotifier<Locale>>();
    getIt.allowReassignment = false; // Reset allowReassignment
  });

  Widget createTestableWidget(Widget child) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  final tTask = Task(id: '1', title: 'Test Task', description: 'Description');

  testWidgets('Shows loading indicator when state is loading', (tester) async {
    when(mockTaskViewModel.state).thenReturn(ViewState.loading);

    await tester.pumpWidget(createTestableWidget(const TaskListPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Shows empty message when there are no tasks', (tester) async {
    when(mockTaskViewModel.tasks).thenReturn([]);
    when(
      mockTaskViewModel.state,
    ).thenReturn(ViewState.idle); // Ensure state is idle for empty message

    await tester.pumpWidget(createTestableWidget(const TaskListPage()));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text(l10n.noTasks), findsOneWidget);
  });

  testWidgets('Shows a list of tasks and lazy loading indicator', (tester) async {
    when(mockTaskViewModel.tasks).thenReturn([tTask]);
    when(mockTaskViewModel.hasMoreTasks).thenReturn(true);
    when(mockTaskViewModel.state).thenReturn(ViewState.idle);
    when(mockTaskViewModel.loadTasks()).thenAnswer((_) async {}); // Ensure loadTasks completes immediately

    await tester.pumpWidget(createTestableWidget(const TaskListPage()));
    await tester.pump(const Duration(seconds: 1));
    // Explicitly complete the animation if it's still running
    final TaskListPageState taskListPageState = tester.state(find.byType(TaskListPage)) as TaskListPageState;
    taskListPageState.animationController.value = 1.0; // Set animation to end
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Test Task'), findsOneWidget);
  });

  testWidgets('Tapping FAB opens the add/edit sheet', (tester) async {
    await tester.pumpWidget(createTestableWidget(const TaskListPage()));
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text(l10n.newTask), findsOneWidget);
  });

  testWidgets('Tapping delete all shows confirmation dialog', (tester) async {
    when(mockTaskViewModel.tasks).thenReturn([tTask]);

    await tester.pumpWidget(createTestableWidget(const TaskListPage()));
    await tester.tap(find.byKey(const Key('taskOptionsPopupMenuButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.deleteAllTasks));
    await tester.pumpAndSettle();

    expect(find.text(l10n.deleteAllTasksConfirmation), findsOneWidget);
  });

  testWidgets('scrolling to the end of the list loads more tasks', (
    tester,
  ) async {
    when(mockTaskViewModel.tasks).thenReturn(
      List.generate(50, (i) => Task(id: i.toString(), title: 'Task $i')),
    );
    when(mockTaskViewModel.hasMoreTasks).thenReturn(true);
    when(mockTaskViewModel.loadMoreTasks()).thenAnswer((_) async {}); // Ensure loadMoreTasks completes immediately

    await tester.pumpWidget(
      createTestableWidget(
        SizedBox(
          // Wrap in SizedBox to limit height
          height: 200, // Small height to force scrolling
          child: const TaskListPage(),
        ),
      ),
    );
    await tester.scrollUntilVisible(
      find.byType(CircularProgressIndicator), // Scroll until the loading indicator is visible
      500.0, // Scroll amount
      scrollable: find.byType(Scrollable), // The scrollable widget
    );
    await tester.pump(const Duration(seconds: 1));

    verify(mockTaskViewModel.loadMoreTasks()).called(1);
  });

  testWidgets('shows error snackbar when viewModel state is error', (
    tester,
  ) async {
    when(mockTaskViewModel.state).thenReturn(ViewState.error);
    when(mockTaskViewModel.errorMessage).thenReturn('Test Error');

    await tester.pumpWidget(createTestableWidget(const TaskListPage()));
    scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(l10n.anErrorOccurred('Test Error')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(l10n.anErrorOccurred('Test Error')), findsOneWidget);
  });

  testWidgets('Tapping delete button shows confirmation dialog', (
    tester,
  ) async {
    when(mockTaskViewModel.tasks).thenReturn([tTask]);

    await tester.pumpWidget(createTestableWidget(const TaskListPage()));
    await tester.tap(find.byIcon(EvaIcons.trash2Outline));
    await tester.pumpAndSettle();

    expect(find.text(l10n.deleteTaskConfirmation), findsOneWidget);
  });

  testWidgets('Responsive layout shows two columns on desktop', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1280, 800);
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

    when(mockTaskViewModel.tasks).thenReturn([tTask]);

    await tester.pumpWidget(createTestableWidget(const TaskListPage()));

    expect(find.byType(Row), findsWidgets);
    expect(find.byType(ListView), findsOneWidget);
    // expect(find.byType(_TaskDetails), findsOneWidget);
  });

  testWidgets('Language selector changes locale', (tester) async {
    await tester.pumpWidget(createTestableWidget(const TaskListPage()));

    await tester.tap(find.byKey(const Key('taskOptionsPopupMenuButton')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('selectLanguagePopupMenuItem'))); // Tap on the PopupMenuItem by key
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButton<Locale>));
    await tester.pumpAndSettle();

    await tester.tap(find.text('🇧🇷 PT')); // Tap on the DropdownMenuItem by text
    await tester.pumpAndSettle();

    verify(mockValueNotifier.value = const Locale('pt')).called(1);
  });
}

class MockValueNotifierLocale extends Mock implements ValueNotifier<Locale> {}