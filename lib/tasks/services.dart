import 'package:todo/core/services.dart';
import 'package:todo/tasks/models.dart';

class TaskService {
  static Future<List<Task>> fetchTasks({required String status}) async {
    try {
      final response = await APIService.get(
        'tasks/?status=$status',
        auth: true,
      );

      if (response is Map && response.containsKey('error')) {
        throw Exception(response['error']);
      }

      if (response is List) {
        return response
            .map((task) => Task.fromJson(task as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Unexpected response format');
    } catch (e) {
      throw Exception('Failed to load tasks: ${e.toString()}');
    }
  }

  static Future<void> createTask({
    required String detail,
    required int priority,
  }) async {
    try {
      final response = await APIService.post('tasks/', {
        'detail': detail,
        'priority': priority,
      }, auth: true);

      if (response is Map && response.containsKey('error')) {
        throw Exception(response['error']);
      }

      return;
    } catch (e) {
      throw Exception('Failed to create task: ${e.toString()}');
    }
  }
}
