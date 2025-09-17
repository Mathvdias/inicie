import 'package:inicie/core/services/storage_service.dart';

class FakeStorageService implements StorageService {
  List<Map<String, dynamic>> tasks = [];

  @override
  Future<void> init() async {
    // Do nothing
  }

  @override
  Future<List<Map<String, dynamic>>> getTasks() async {
    return tasks;
  }

  @override
  Future<void> saveTasks(List<Map<String, dynamic>> tasks) async {
    this.tasks = tasks;
  }
}
