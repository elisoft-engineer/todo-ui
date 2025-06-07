import 'package:flutter/material.dart';
import 'package:todo/core/styles.dart';
import 'package:todo/tasks/forms.dart';
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

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
                      return Container(
                        margin: EdgeInsets.only(top: 12, left: 8, right: 8),
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 8.0,
                        ),

                        decoration: BoxDecoration(
                          color: const Color(0x218FC9C4),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: ListTile(
                          key: Key(task.id),
                          leading: Container(
                            height: 18,
                            width: 18,
                            decoration: BoxDecoration(
                              color: _getPriorityColor(task.priority),
                              borderRadius: BorderRadius.all(
                                Radius.circular(9),
                              ),
                            ),
                          ),
                          title: Text(
                            task.detail,
                            style: CustomTextStyles.b1.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          subtitle: Text(
                            task.humanizedTime,
                            style: CustomTextStyles.s2,
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => TaskEditForm(
                                      task: task,
                                      onSuccess: () => {},
                                    ),
                              );
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.teal[300],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 16,
                                color: colorScheme.surface,
                              ),
                            ),
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
