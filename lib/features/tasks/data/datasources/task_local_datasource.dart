import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:inicie/core/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Map<String, dynamic>> _decodeTasks(String tasksString) {
  final List<dynamic> decoded = jsonDecode(tasksString);
  return decoded.cast<Map<String, dynamic>>();
}

String _encodeTasks(List<Map<String, dynamic>> tasks) {
  return jsonEncode(tasks);
}

class SharedPreferencesStorageService implements StorageService {
  static const _kTasksKey = 'tasks';

  SharedPreferences? _prefs;

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _instance {
    if (_prefs == null) {
      throw Exception('SharedPreferences not initialized. Call init() first.');
    }
    return _prefs!;
  }

  @override
  Future<List<Map<String, dynamic>>> getTasks() async {
    final tasksString = _instance.getString(_kTasksKey);
    if (tasksString != null && tasksString.isNotEmpty) {
      return await compute(_decodeTasks, tasksString);
    }
    return [];
  }

  @override
  Future<void> saveTasks(List<Map<String, dynamic>> tasks) async {
    final tasksString = await compute(_encodeTasks, tasks);
    await _instance.setString(_kTasksKey, tasksString);
  }
}
