import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/l10n/app_localizations_en.dart';

void main() {
  group('AppLocalizationsEn', () {
    late AppLocalizationsEn appLocalizations;

    setUp(() {
      appLocalizations = AppLocalizationsEn();
    });

    test('appTitle returns correct string', () {
      expect(appLocalizations.appTitle, 'Inicie Tasks');
    });

    test('editTask returns correct string', () {
      expect(appLocalizations.editTask, 'Edit Task');
    });

    test('newTask returns correct string', () {
      expect(appLocalizations.newTask, 'New Task');
    });

    test('title returns correct string', () {
      expect(appLocalizations.title, 'Title');
    });

    test('titleHint returns correct string', () {
      expect(appLocalizations.titleHint, 'What do you need to do?');
    });

    test('titleEmptyError returns correct string', () {
      expect(appLocalizations.titleEmptyError, 'Title cannot be empty.');
    });

    test('description returns correct string', () {
      expect(appLocalizations.description, 'Description');
    });

    test('descriptionHint returns correct string', () {
      expect(appLocalizations.descriptionHint, '(Optional)');
    });

    test('setReminder returns correct string', () {
      expect(appLocalizations.setReminder, 'Set Reminder');
    });

    test('tapToSetTime returns correct string', () {
      expect(appLocalizations.tapToSetTime, 'Tap to set time');
    });

    test('cancel returns correct string', () {
      expect(appLocalizations.cancel, 'Cancel');
    });

    test('save returns correct string', () {
      expect(appLocalizations.save, 'Save');
    });

    test('deleteTask returns correct string', () {
      expect(appLocalizations.deleteTask, 'Delete Task?');
    });

    test('deleteTaskConfirmation returns correct string', () {
      expect(appLocalizations.deleteTaskConfirmation, 'Are you sure you want to delete this task?');
    });

    test('delete returns correct string', () {
      expect(appLocalizations.delete, 'Delete');
    });

    test('noTasks returns correct string', () {
      expect(appLocalizations.noTasks, 'No tasks yet. Add one!');
    });

    test('anErrorOccurred returns correct string with error', () {
      final error = 'Test Error';
      expect(appLocalizations.anErrorOccurred(error), 'An error occurred: Test Error');
    });

    test('taskDeleted returns correct string', () {
      expect(appLocalizations.taskDeleted, 'Task deleted');
    });

    test('taskAdded returns correct string', () {
      expect(appLocalizations.taskAdded, 'Task added');
    });

    test('taskUpdated returns correct string', () {
      expect(appLocalizations.taskUpdated, 'Task updated');
    });
  });
}
