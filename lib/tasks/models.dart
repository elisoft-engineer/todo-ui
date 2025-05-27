class Task {
  final String id;
  final String detail;
  final int priority;
  final String status;
  final String humanizedTime;

  Task({
    required this.id,
    required this.detail,
    required this.priority,
    required this.status,
    required this.humanizedTime,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      detail: json['detail'],
      priority: json['priority'],
      status: json['status'],
      humanizedTime: json['humanized_time'],
    );
  }
}
