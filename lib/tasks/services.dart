import 'package:todo/core/services.dart';
import 'package:todo/tasks/models.dart';

class TaskService {
  static Future<List<Task>> fetchTasks(String status) async {
    final response = await APIService.get('tasks/?status=$status', auth: true);
    if (response is List) {
      return response
          .map((task) => Task.fromJson(task as Map<String, dynamic>))
          .toList();
    } else if (response is Map) {
      print(response);
      throw Exception(
        response['error'] ?? "An error occured while trying to fetch tasks",
      );
    } else {
      throw Exception("Unexpected response format");
    }
  }
}
