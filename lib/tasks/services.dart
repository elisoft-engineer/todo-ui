import 'package:todo/core/services.dart';
import 'package:todo/tasks/models.dart';

class TaskService {
  static Future<List<Task>> fetchTasks({required String status}) async {
    try {
      final response = await APIService.get(
        'tasks/',
        auth: true,
        q: '?status=$status',
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

  static Future<void> updateTask({
    required String id,
    required String detail,
    required int priority,
  }) async {
    try {
      final response = await APIService.put('tasks/$id/', {
        'detail': detail,
        'priority': priority,
      }, auth: true);

      if (response is Map && response.containsKey('error')) {
        throw Exception(response['error']);
      }

      return;
    } catch (e) {
      throw Exception('Failed to update task: ${e.toString()}');
    }
  }

  static Future<void> deleteTask({required String id}) async {
    try {
      final response = await APIService.delete('tasks/$id/', auth: true);

      if (response is Map && response.containsKey('error')) {
        throw Exception(response['error']);
      }

      return;
    } catch (e) {
      throw Exception('Failed to delete task: ${e.toString()}');
    }
  }

  static Future<void> patchTask({required String id}) async {
    try {
      final response = await APIService.patch('tasks/$id/', auth: true);

      if (response is Map && response.containsKey('error')) {
        throw Exception(response['error']);
      }

      return;
    } catch (e) {
      throw Exception('Failed to push task: ${e.toString()}');
    }
  }

  static Future<void> holdTask({required String id}) async {
    try {
      final response = await APIService.patch(
        'tasks/$id/',
        auth: true,
        q: '?to-onhold=true',
      );

      if (response is Map && response.containsKey('error')) {
        throw Exception(response['error']);
      }

      return;
    } catch (e) {
      throw Exception('Failed to hold task: ${e.toString()}');
    }
  }
}
