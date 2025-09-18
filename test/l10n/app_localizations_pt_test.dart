import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/l10n/app_localizations_pt.dart';

void main() {
  group('AppLocalizationsPt', () {
    late AppLocalizationsPt appLocalizations;

    setUp(() {
      appLocalizations = AppLocalizationsPt();
    });

    test('appTitle returns correct string', () {
      expect(appLocalizations.appTitle, 'Inicie Tarefas');
    });

    test('editTask returns correct string', () {
      expect(appLocalizations.editTask, 'Editar Tarefa');
    });

    test('newTask returns correct string', () {
      expect(appLocalizations.newTask, 'Nova Tarefa');
    });

    test('title returns correct string', () {
      expect(appLocalizations.title, 'Título');
    });

    test('titleHint returns correct string', () {
      expect(appLocalizations.titleHint, 'O que você precisa fazer?');
    });

    test('titleEmptyError returns correct string', () {
      expect(appLocalizations.titleEmptyError, 'O título não pode estar vazio.');
    });

    test('description returns correct string', () {
      expect(appLocalizations.description, 'Descrição');
    });

    test('descriptionHint returns correct string', () {
      expect(appLocalizations.descriptionHint, '(Opcional)');
    });

    test('setReminder returns correct string', () {
      expect(appLocalizations.setReminder, 'Definir Lembrete');
    });

    test('tapToSetTime returns correct string', () {
      expect(appLocalizations.tapToSetTime, 'Toque para definir a hora');
    });

    test('cancel returns correct string', () {
      expect(appLocalizations.cancel, 'Cancelar');
    });

    test('save returns correct string', () {
      expect(appLocalizations.save, 'Salvar');
    });

    test('deleteTask returns correct string', () {
      expect(appLocalizations.deleteTask, 'Deletar Tarefa?');
    });

    test('deleteTaskConfirmation returns correct string', () {
      expect(appLocalizations.deleteTaskConfirmation, 'Você tem certeza que quer deletar esta tarefa?');
    });

    test('delete returns correct string', () {
      expect(appLocalizations.delete, 'Deletar');
    });

    test('noTasks returns correct string', () {
      expect(appLocalizations.noTasks, 'Nenhuma tarefa ainda. Adicione uma!');
    });

    test('anErrorOccurred returns correct string with error', () {
      final error = 'Test Error';
      expect(appLocalizations.anErrorOccurred(error), 'Ocorreu um erro: Test Error');
    });

    test('taskDeleted returns correct string', () {
      expect(appLocalizations.taskDeleted, 'Tarefa deletada');
    });

    test('taskAdded returns correct string', () {
      expect(appLocalizations.taskAdded, 'Tarefa adicionada');
    });

    test('taskUpdated returns correct string', () {
      expect(appLocalizations.taskUpdated, 'Tarefa atualizada');
    });

    test('deleteAllTasks returns correct string', () {
      expect(appLocalizations.deleteAllTasks, 'Deletar Todas as Tarefas');
    });

    test('deleteAllTasksConfirmation returns correct string', () {
      expect(appLocalizations.deleteAllTasksConfirmation, 'Você tem certeza que quer deletar todas as tarefas? Esta ação não pode ser desfeita.');
    });

    test('deleteAll returns correct string', () {
      expect(appLocalizations.deleteAll, 'Deletar Tudo');
    });

    test('selectTaskPrompt returns correct string', () {
      expect(appLocalizations.selectTaskPrompt, 'Selecione uma tarefa para ver seus detalhes');
    });

    test('reminderOn returns correct string with date', () {
      final date = '2025-12-31';
      expect(appLocalizations.reminderOn(date), 'Lembrete em $date');
    });

    test('expand returns correct string', () {
      expect(appLocalizations.expand, 'Expandir');
    });

    test('collapse returns correct string', () {
      expect(appLocalizations.collapse, 'Recolher');
    });

    test('selectLanguage returns correct string', () {
      expect(appLocalizations.selectLanguage, 'Selecionar Idioma');
    });

    test('edit returns correct string', () {
      expect(appLocalizations.edit, 'Editar');
    });
  });
}
