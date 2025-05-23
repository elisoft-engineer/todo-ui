class Task {
  final String id;
  final String detail;
  final int priority;
  final String status;

  Task({
    required this.id,
    required this.detail,
    required this.priority,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      detail: json['detail'],
      priority: json['priority'],
      status: json['status'],
    );
  }
}
