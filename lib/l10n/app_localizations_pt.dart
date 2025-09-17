// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Inicie Tarefas';

  @override
  String get editTask => 'Editar Tarefa';

  @override
  String get newTask => 'Nova Tarefa';

  @override
  String get title => 'Título';

  @override
  String get titleHint => 'O que você precisa fazer?';

  @override
  String get titleEmptyError => 'O título não pode estar vazio.';

  @override
  String get description => 'Descrição';

  @override
  String get descriptionHint => '(Opcional)';

  @override
  String get setReminder => 'Definir Lembrete';

  @override
  String get tapToSetTime => 'Toque para definir a hora';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get deleteTask => 'Deletar Tarefa?';

  @override
  String get deleteTaskConfirmation =>
      'Você tem certeza que quer deletar esta tarefa?';

  @override
  String get delete => 'Deletar';

  @override
  String get noTasks => 'Nenhuma tarefa ainda. Adicione uma!';

  @override
  String anErrorOccurred(Object error) {
    return 'Ocorreu um erro: $error';
  }

  @override
  String get taskDeleted => 'Tarefa deletada';

  @override
  String get taskAdded => 'Tarefa adicionada';

  @override
  String get taskUpdated => 'Tarefa atualizada';

  @override
  String get deleteAllTasks => 'Deletar Todas as Tarefas';

  @override
  String get deleteAllTasksConfirmation =>
      'Você tem certeza que quer deletar todas as tarefas? Esta ação não pode ser desfeita.';

  @override
  String get deleteAll => 'Deletar Tudo';

  @override
  String get selectTaskPrompt => 'Selecione uma tarefa para ver seus detalhes';

  @override
  String reminderOn(Object date) {
    return 'Lembrete em $date';
  }

  @override
  String get expand => 'Expandir';

  @override
  String get collapse => 'Recolher';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get edit => 'Editar';
}
