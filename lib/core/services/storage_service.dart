abstract class StorageService {
  Future<void> init();

  Future<List<Map<String, dynamic>>> getTasks();

  Future<void> saveTasks(List<Map<String, dynamic>> tasks);
}
