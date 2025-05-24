import 'package:flutter/material.dart';
import 'package:todo/core/styles.dart';
import 'package:todo/tasks/models.dart';
import 'package:todo/tasks/services.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final Future<List<Task>> tasks = TaskService.fetchTasks("todo");

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Todo",
        style: CustomTextStyles.h1.copyWith(color: CustomColors.textColor),
      ),
    );
  }
}
