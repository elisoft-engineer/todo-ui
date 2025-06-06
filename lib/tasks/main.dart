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

enum PopupMenuItems { profile, settings }

class _TaskViewSetState extends State<TaskViewSet> {
  int _selectedIndex = 0;
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
          PopupMenuButton<PopupMenuItems>(
            icon: Icon(Icons.more_vert_outlined),
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: PopupMenuItems.profile,
                    child: SizedBox(
                      width: 144,
                      child: Row(
                        spacing: 12,
                        children: [Icon(Icons.person), Text('Profile')],
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: PopupMenuItems.settings,
                    child: SizedBox(
                      width: 144,
                      child: Row(
                        spacing: 12,
                        children: [Icon(Icons.settings), Text('Settings')],
                      ),
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: TaskList(taskStatus: taskStatus),
      floatingActionButton:
          taskStatus == TaskStatus.todo
              ? IconButton(
                onPressed:
                    () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder:
                          (context) => TaskCreationForm(onSuccess: () => {}),
                    ),
                icon: Icon(Icons.add, size: 30),
                style: IconButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.brightness ==
                              Brightness.dark
                          ? colorScheme.onSecondary
                          : colorScheme.inversePrimary,
                ),
              )
              : null,
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.pending_actions_outlined),
            label: 'Todo',
          ),
          NavigationDestination(icon: Icon(Icons.autorenew), label: 'Doing'),
          NavigationDestination(icon: Icon(Icons.check_circle), label: 'Done'),
          NavigationDestination(
            icon: Icon(Icons.pause_circle),
            label: 'On Hold',
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: (selectedIndex) {
          setState(() {
            _selectedIndex = selectedIndex;
            taskStatus =
                _selectedIndex == 0
                    ? TaskStatus.todo
                    : _selectedIndex == 1
                    ? TaskStatus.doing
                    : _selectedIndex == 2
                    ? TaskStatus.done
                    : TaskStatus.onHold;
          });
        },
      ),
    );
  }
}
