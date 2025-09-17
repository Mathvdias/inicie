import 'package:inicie/l10n/app_localizations.dart' show AppLocalizations;

class MockAppLocalizations implements AppLocalizations {
  @override
  String get appTitle => 'Mock App Title';

  @override
  String get cancel => 'Mock Cancel';

  @override
  String get delete => 'Mock Delete';

  @override
  String get deleteTask => 'Mock Delete Task?';

  @override
  String get deleteTaskConfirmation => 'Mock Delete Task Confirmation';

  @override
  String get description => 'Mock Description';

  @override
  String get descriptionHint => 'Mock (Optional)';

  @override
  String get editTask => 'Mock Edit Task';

  @override
  String get newTask => 'Mock New Task';

  @override
  String get save => 'Mock Save';

  @override
  String get setReminder => 'Mock Set Reminder';

  @override
  String get tapToSetTime => 'Mock Tap to set time';

  @override
  String get title => 'Mock Title';

  @override
  String get titleEmptyError => 'Mock Title cannot be empty.';

  @override
  String get titleHint => 'Mock What do you need to do?';

  @override
  String anErrorOccurred(Object error) => 'Mock An error occurred: $error';

  @override
  String get noTasks => 'Mock No tasks yet. Add one!';

  @override
  String get taskAdded => 'Mock Task Added';

  @override
  String get taskDeleted => 'Mock Task Deleted';

  @override
  String get taskUpdated => 'Mock Task Updated';

  @override
  String get localeName => '';

  @override
  // TODO: implement deleteAll
  String get deleteAll => throw UnimplementedError();

  @override
  // TODO: implement deleteAllTasks
  String get deleteAllTasks => throw UnimplementedError();

  @override
  // TODO: implement deleteAllTasksConfirmation
  String get deleteAllTasksConfirmation => throw UnimplementedError();

  @override
  String reminderOn(Object date) {
    // TODO: implement reminderOn
    throw UnimplementedError();
  }

  @override
  // TODO: implement selectTaskPrompt
  String get selectTaskPrompt => throw UnimplementedError();

  @override
  // TODO: implement collapse
  String get collapse => throw UnimplementedError();

  @override
  // TODO: implement expand
  String get expand => throw UnimplementedError();

  @override
  // TODO: implement selectLanguage
  String get selectLanguage => throw UnimplementedError();

  @override
  // TODO: implement edit
  String get edit => throw UnimplementedError();
}
