import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';

void main() {
  group('Task', () {
    test('Task can be created with all fields', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Description',
        isCompleted: true,
        reminderDateTime: DateTime(2024, 1, 1),
      );
      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.description, 'Description');
      expect(task.isCompleted, true);
      expect(task.reminderDateTime, DateTime(2024, 1, 1));
    });

    test('Task can be created with minimal fields', () {
      final task = Task(
        title: 'Test Task',
      );
      expect(task.id, isNotNull);
      expect(task.title, 'Test Task');
      expect(task.description, isNull);
      expect(task.isCompleted, false);
      expect(task.reminderDateTime, isNull);
    });

    test('copyWith creates a new Task with updated fields', () {
      final originalTask = Task(
        id: '1',
        title: 'Original Title',
        description: 'Original Description',
        isCompleted: false,
        reminderDateTime: DateTime(2024, 1, 1),
      );

      final updatedTask = originalTask.copyWith(
        title: 'Updated Title',
        isCompleted: true,
      );

      expect(updatedTask.id, '1');
      expect(updatedTask.title, 'Updated Title');
      expect(updatedTask.description, 'Original Description');
      expect(updatedTask.isCompleted, true);
      expect(updatedTask.reminderDateTime, DateTime(2024, 1, 1));
      expect(originalTask, isNot(equals(updatedTask)));
    });

    test('toJson converts Task to JSON map', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Description',
        isCompleted: true,
        reminderDateTime: DateTime(2024, 1, 1, 10, 30),
      );
      final json = task.toJson();
      expect(json['id'], '1');
      expect(json['title'], 'Test Task');
      expect(json['description'], 'Description');
      expect(json['isCompleted'], true);
      expect(json['reminderDateTime'], DateTime(2024, 1, 1, 10, 30).toIso8601String());
    });

    test('toJson converts Task to JSON map with nulls', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
      );
      final json = task.toJson();
      expect(json['id'], '1');
      expect(json['title'], 'Test Task');
      expect(json['description'], isNull);
      expect(json['isCompleted'], false);
      expect(json['reminderDateTime'], isNull);
    });

    test('fromJson converts JSON map to Task', () {
      final json = {
        'id': '1',
        'title': 'Test Task',
        'description': 'Description',
        'isCompleted': true,
        'reminderDateTime': DateTime(2024, 1, 1).toIso8601String(),
      };
      final task = Task.fromJson(json);
      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.description, 'Description');
      expect(task.isCompleted, true);
      expect(task.reminderDateTime, DateTime(2024, 1, 1));
    });

    test('fromJson converts JSON map to Task with null reminderDateTime', () {
      final json = {
        'id': '1',
        'title': 'Test Task',
        'description': 'Description',
        'isCompleted': true,
        'reminderDateTime': null,
      };
      final task = Task.fromJson(json);
      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.description, 'Description');
      expect(task.isCompleted, true);
      expect(task.reminderDateTime, isNull);
    });

    test('equality operator works correctly', () {
      final task1 = Task(id: '1', title: 'Test Task', isCompleted: false, reminderDateTime: DateTime(2024, 1, 1));
      final task2 = Task(id: '1', title: 'Test Task', isCompleted: false, reminderDateTime: DateTime(2024, 1, 1));
      final task3 = Task(id: '2', title: 'Another Task', isCompleted: true, reminderDateTime: DateTime(2024, 1, 2));

      expect(task1, equals(task2));
      expect(task1, isNot(equals(task3)));
    });

    test('equality operator works correctly with null reminderDateTime', () {
      final task1 = Task(id: '1', title: 'Test Task', isCompleted: false, reminderDateTime: null);
      final task2 = Task(id: '1', title: 'Test Task', isCompleted: false, reminderDateTime: null);
      final task3 = Task(id: '1', title: 'Test Task', isCompleted: false, reminderDateTime: DateTime(2024, 1, 1));

      expect(task1, equals(task2));
      expect(task1, isNot(equals(task3)));
    });

    test('hashCode is consistent', () {
      final task1 = Task(id: '1', title: 'Test Task', isCompleted: false, reminderDateTime: DateTime(2024, 1, 1));
      final task2 = Task(id: '1', title: 'Test Task', isCompleted: false, reminderDateTime: DateTime(2024, 1, 1));

      expect(task1.hashCode, equals(task2.hashCode));
    });

    test('hashCode is consistent with null reminderDateTime', () {
      final task1 = Task(id: '1', title: 'Test Task', isCompleted: false, reminderDateTime: null);
      final task2 = Task(id: '1', title: 'Test Task', isCompleted: false, reminderDateTime: null);

      expect(task1.hashCode, equals(task2.hashCode));
    });
  });
}
