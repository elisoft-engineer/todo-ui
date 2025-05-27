import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:todo/components/app_bar.dart';
import 'package:todo/core/styles.dart';
import 'package:todo/tasks/models.dart';
import 'package:todo/tasks/services.dart';

enum TaskStatus { todo, doing, done, onHold }

class TaskViewSet extends StatefulWidget {
  const TaskViewSet({super.key});

  @override
  State<TaskViewSet> createState() => _TaskViewSetState();
}

class _TaskViewSetState extends State<TaskViewSet> {
  int _index = 2;
  TaskStatus taskStatus = TaskStatus.done;

  get _getTitle =>
      _index == 0
          ? "Todo"
          : _index == 1
          ? "Doing"
          : _index == 2
          ? "Done"
          : "On Hold";

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: TopBar(title: _getTitle),
      body: TaskList(taskStatus: taskStatus),
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          Icon(Icons.list_alt, color: colorScheme.primary),
          Icon(Icons.autorenew, color: colorScheme.primary),
          Icon(Icons.check_circle, color: colorScheme.primary),
          Icon(Icons.pause_circle_filled, color: colorScheme.primary),
        ],
        index: _index,
        height: 55,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 250),
        backgroundColor: Colors.transparent,
        color: colorScheme.inversePrimary,
        buttonBackgroundColor: colorScheme.inversePrimary,
        onTap: (selected) {
          setState(() {
            _index = selected;
            taskStatus =
                _index == 0
                    ? TaskStatus.todo
                    : _index == 1
                    ? TaskStatus.doing
                    : _index == 2
                    ? TaskStatus.done
                    : TaskStatus.onHold;
          });
        },
      ),
    );
  }
}

class TaskList extends StatefulWidget {
  final TaskStatus taskStatus;
  const TaskList({super.key, required this.taskStatus});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  Future<List<Task>>? _tasksFuture;

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
  void initState() {
    super.initState();
    _fetchTasks();
  }

  void _fetchTasks() {
    setState(() {
      _tasksFuture = TaskService.fetchTasks(
        widget.taskStatus == TaskStatus.todo
            ? "todo"
            : widget.taskStatus == TaskStatus.doing
            ? "doing"
            : widget.taskStatus == TaskStatus.done
            ? "done"
            : "on hold",
      );
    });
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
          onRefresh: () async => _fetchTasks(),
          child:
              tasks.isEmpty
                  ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const Center(child: Text('No tasks found')),
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
