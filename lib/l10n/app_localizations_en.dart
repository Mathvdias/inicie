// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Inicie Tasks';

  @override
  String get editTask => 'Edit Task';

  @override
  String get newTask => 'New Task';

  @override
  String get title => 'Title';

  @override
  String get titleHint => 'What do you need to do?';

  @override
  String get titleEmptyError => 'Title cannot be empty.';

  @override
  String get description => 'Description';

  @override
  String get descriptionHint => '(Optional)';

  @override
  String get setReminder => 'Set Reminder';

  @override
  String get tapToSetTime => 'Tap to set time';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get deleteTask => 'Delete Task?';

  @override
  String get deleteTaskConfirmation =>
      'Are you sure you want to delete this task?';

  @override
  String get delete => 'Delete';

  @override
  String get noTasks => 'No tasks yet. Add one!';

  @override
  String anErrorOccurred(Object error) {
    return 'An error occurred: $error';
  }

  @override
  String get taskDeleted => 'Task deleted';

  @override
  String get taskAdded => 'Task added';

  @override
  String get taskUpdated => 'Task updated';

  @override
  String get deleteAllTasks => 'Delete All Tasks';

  @override
  String get deleteAllTasksConfirmation =>
      'Are you sure you want to delete all tasks? This cannot be undone.';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get selectTaskPrompt => 'Select a task to see its details';

  @override
  String reminderOn(Object date) {
    return 'Reminder on $date';
  }

  @override
  String get expand => 'Expand';

  @override
  String get collapse => 'Collapse';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get edit => 'Edit';
}
