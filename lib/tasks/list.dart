import 'package:flutter/material.dart';
import 'package:todo/core/styles.dart';
import 'package:todo/tasks/main.dart';
import 'package:todo/tasks/models.dart';
import 'package:todo/tasks/services.dart';

class TaskList extends StatefulWidget {
  final TaskStatus taskStatus;
  const TaskList({super.key, required this.taskStatus});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  Future<List<Task>>? _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = _fetchTasks();
  }

  @override
  void didUpdateWidget(covariant TaskList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.taskStatus != widget.taskStatus) {
      setState(() {
        _tasksFuture = _fetchTasks();
      });
    }
  }

  Future<List<Task>> _fetchTasks() {
    Future<List<Task>> tasks = TaskService.fetchTasks(
      status:
          widget.taskStatus == TaskStatus.todo
              ? "todo"
              : widget.taskStatus == TaskStatus.doing
              ? "doing"
              : widget.taskStatus == TaskStatus.done
              ? "done"
              : "on hold",
    );
    return tasks;
  }

  Color _getPriorityColor(int priority) {
    if (priority == 5) {
      return Color(0xffef2000);
    } else if (priority == 4) {
      return Colors.amber;
    } else {
      return Color.fromARGB(255, 12, 189, 20);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: _tasksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final tasks = snapshot.data ?? [];

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _tasksFuture = _fetchTasks();
            });
          },
          child:
              tasks.isEmpty
                  ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const Center(
                        child: Text(
                          'No tasks found',
                          style: CustomTextStyles.b2,
                        ),
                      ),
                    ),
                  )
                  : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return ListTile(
                        key: Key(task.id),
                        leading: Icon(
                          widget.taskStatus == TaskStatus.todo
                              ? Icons.pending_actions_outlined
                              : widget.taskStatus == TaskStatus.doing
                              ? Icons.autorenew
                              : widget.taskStatus == TaskStatus.done
                              ? Icons.check_circle
                              : Icons.pause,
                        ),
                        title: Text(
                          task.detail,
                          style: CustomTextStyles.b2.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        subtitle: Text(
                          task.humanizedTime,
                          style: CustomTextStyles.s2.copyWith(
                            color: CustomColors.textColor,
                          ),
                        ),
                        trailing: Container(
                          height: 8,
                          width: 24,
                          decoration: BoxDecoration(
                            color: _getPriorityColor(task.priority),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                      );
                    },
                  ),
        );
      },
    );
  }
}
