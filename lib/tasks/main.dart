import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:todo/components/app_bar.dart';
import 'package:todo/tasks/forms.dart';
import 'package:todo/tasks/list.dart';

enum TaskStatus { todo, doing, done, onHold }

class TaskViewSet extends StatefulWidget {
  const TaskViewSet({super.key});

  @override
  State<TaskViewSet> createState() => _TaskViewSetState();
}

class _TaskViewSetState extends State<TaskViewSet> {
  int _index = 0;
  TaskStatus taskStatus = TaskStatus.todo;

  get _getTitle {
    switch (taskStatus) {
      case TaskStatus.todo:
        return "Todo";
      case TaskStatus.doing:
        return "Doing";
      case TaskStatus.done:
        return "Done";
      case TaskStatus.onHold:
        return "On Hold";
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: TopBar(
        title: _getTitle,
        actions: [
          IconButton(
            onPressed:
                () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => TaskCreationForm(onSuccess: () => {}),
                ),
            icon: Icon(Icons.add),
            iconSize: 30,
          ),
        ],
      ),
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
