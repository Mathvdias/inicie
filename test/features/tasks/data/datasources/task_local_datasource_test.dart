import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferencesStorageService dataSource;

  setUp(() async {
    dataSource = SharedPreferencesStorageService();
  });

  final tTaskMaps = [
    {'id': '1', 'title': 'Task 1', 'isCompleted': false},
    {'id': '2', 'title': 'Task 2', 'isCompleted': true},
  ];

  group('getTasks', () {
    test('should return a list of task maps from SharedPreferences', () async {
      // arrange
      SharedPreferences.setMockInitialValues({
        'tasks': jsonEncode(tTaskMaps),
      });
      await dataSource.init();
      // act
      final result = await dataSource.getTasks();
      // assert
      expect(result, tTaskMaps);
    });

    test('should return an empty list when there are no tasks in SharedPreferences', () async {
      // arrange
      SharedPreferences.setMockInitialValues({});
      await dataSource.init();
      // act
      final result = await dataSource.getTasks();
      // assert
      expect(result, []);
    });
  });

  group('saveTasks', () {
    test('should call SharedPreferences.setString with the correct value', () async {
      // arrange
      SharedPreferences.setMockInitialValues({});
      await dataSource.init();
      // act
      await dataSource.saveTasks(tTaskMaps);
      // assert
      final prefs = await SharedPreferences.getInstance();
      final expectedJsonString = jsonEncode(tTaskMaps);
      expect(prefs.getString('tasks'), expectedJsonString);
    });
  });

  test('should throw an exception if SharedPreferences is not initialized', () async {
    expect(() => dataSource.getTasks(), throwsA(isA<Exception>()));
  });
}
