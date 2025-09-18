import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/features/tasks/presentation/viewmodels/i_task_viewmodel.dart'; // Corrected import
import 'package:inicie/features/tasks/presentation/widgets/add_edit_task_sheet.dart';
import 'package:inicie/l10n/app_localizations.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../views/task_list_page_test.mocks.dart'; // Assuming this mock is still needed

@GenerateMocks([ITaskViewModel]) // Corrected mock generation
void main() {
  late MockITaskViewModel mockTaskViewModel; // Corrected type

  setUp(() {
    mockTaskViewModel = MockITaskViewModel(); // Corrected instantiation
  });

  Widget createTestableWidget(Widget child) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Material(child: child),
    );
  }

  testWidgets('should show add task sheet', (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestableWidget(
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                showAddEditTaskSheet(context, mockTaskViewModel);
              },
              child: const Text('Show Sheet'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('New Task'), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });

  testWidgets('should show edit task sheet', (WidgetTester tester) async {
    final task = Task(
      id: '1',
      title: 'Test Task',
      description: 'Test Description',
    );

    await tester.pumpWidget(
      createTestableWidget(
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                showAddEditTaskSheet(context, mockTaskViewModel, task: task);
              },
              child: const Text('Show Sheet'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('Edit Task'), findsOneWidget);
    expect(find.text('Test Task'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
  });

  testWidgets('should call addTask when saving a new task', (
    WidgetTester tester,
  ) async {
    when(
      mockTaskViewModel.addTask(
        // Corrected to named arguments
        title: anyNamed('title'),
        description: anyNamed('description'),
        reminderDateTime: anyNamed('reminderDateTime'),
      ),
    ).thenAnswer((_) async => {});

    await tester.pumpWidget(
      createTestableWidget(
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                showAddEditTaskSheet(context, mockTaskViewModel);
              },
              child: const Text('Show Sheet'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'New Task Title');
    await tester.enterText(
      find.byType(TextFormField).last,
      'New Task Description',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    verify(
      mockTaskViewModel.addTask(
        // Corrected to named arguments
        title: 'New Task Title',
        description: 'New Task Description',
      ),
    ).called(1);
  });

  testWidgets('should call updateTask when saving an existing task', (
    WidgetTester tester,
  ) async {
    final task = Task(
      id: '1',
      title: 'Test Task',
      description: 'Test Description',
    );
    when(mockTaskViewModel.updateTask(any)).thenAnswer((_) async => {});

    await tester.pumpWidget(
      createTestableWidget(
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                showAddEditTaskSheet(context, mockTaskViewModel, task: task);
              },
              child: const Text('Show Sheet'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).first,
      'Updated Task Title',
    );
    await tester.enterText(
      find.byType(TextFormField).last,
      'Updated Task Description',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final updatedTask = task.copyWith(
      title: 'Updated Task Title',
      description: 'Updated Task Description',
    );

    verify(mockTaskViewModel.updateTask(updatedTask)).called(1);
  });
}
