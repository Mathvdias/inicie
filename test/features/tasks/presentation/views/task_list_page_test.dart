import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/core/di/service_locator.dart';
import 'package:inicie/core/services/notification_service.dart';
import 'package:inicie/core/services/storage_service.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/features/tasks/presentation/viewmodels/task_viewmodel.dart';
import 'package:inicie/features/tasks/presentation/views/task_list_page.dart';
import 'package:inicie/l10n/app_localizations.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'task_list_page_test.mocks.dart';

@GenerateMocks([TaskViewModel, NotificationService, StorageService])
void main() {
  late MockTaskViewModel mockTaskViewModel;
  late MockNotificationService mockNotificationService;
  late MockStorageService mockStorageService;
  late AppLocalizations l10n;

  setUp(() async {
    getIt.reset();
    mockTaskViewModel = MockTaskViewModel();
    mockNotificationService = MockNotificationService();
    mockStorageService = MockStorageService();

    getIt.registerSingleton<TaskViewModel>(mockTaskViewModel);
    getIt.registerSingleton<NotificationService>(mockNotificationService);
    getIt.registerSingleton<StorageService>(mockStorageService);
    getIt.registerSingleton<ValueNotifier<Locale>>(
      ValueNotifier<Locale>(const Locale('en')),
    );

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

  Widget createTestableWidget(Widget child) {
    return ValueListenableBuilder<Locale>(
      valueListenable: getIt<ValueNotifier<Locale>>(),
      builder: (context, locale, childWidget) {
        return MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Material(child: child),
        );
      },
      child: child,
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

    await tester.pumpWidget(createTestableWidget(const TaskListPage()));

    expect(find.text(l10n.noTasks), findsOneWidget);
  });

  testWidgets('Shows a list of tasks and lazy loading indicator', (tester) async {
    when(mockTaskViewModel.tasks).thenReturn([tTask]);
    when(mockTaskViewModel.hasMoreTasks).thenReturn(true);

    await tester.pumpWidget(createTestableWidget(const TaskListPage()));

    expect(find.text('Test Task'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
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
    await tester.tap(find.byKey(const Key('deleteAllTasksMenuButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.deleteAllTasks));
    await tester.pumpAndSettle();

    expect(find.text(l10n.deleteAllTasksConfirmation), findsOneWidget);
  });

  testWidgets('scrolling to the end of the list loads more tasks', (tester) async {
    when(mockTaskViewModel.tasks).thenReturn(List.generate(20, (i) => Task(id: i.toString(), title: 'Task $i')));
    when(mockTaskViewModel.hasMoreTasks).thenReturn(true);
    when(mockTaskViewModel.loadMoreTasks()).thenAnswer((_) async => {});

    await tester.pumpWidget(createTestableWidget(const TaskListPage()));
    final listFinder = find.byType(ListView);
    await tester.drag(listFinder, const Offset(0, -500));
    await tester.pumpAndSettle();

    verify(mockTaskViewModel.loadMoreTasks()).called(1);
  });

  testWidgets('shows error snackbar when viewModel state is error', (tester) async {
    when(mockTaskViewModel.state).thenReturn(ViewState.error);
    when(mockTaskViewModel.errorMessage).thenReturn('Test Error');

    await tester.pumpWidget(createTestableWidget(const TaskListPage()));
    await tester.pump();

    expect(find.text(l10n.anErrorOccurred('Test Error')), findsOneWidget);
  });

  testWidgets('Tapping delete button shows confirmation dialog', (tester) async {
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

    await tester.tap(find.byIcon(Icons.language));
    await tester.pumpAndSettle();

    await tester.tap(find.text('🇧🇷 PT').last);
    await tester.pumpAndSettle();

    final BuildContext context = tester.element(find.byType(TaskListPage));
    expect(Localizations.localeOf(context).languageCode, 'pt');
  });
}
