import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:todo/tasks/doing.dart';
import 'package:todo/tasks/done.dart';
import 'package:todo/tasks/on_hold.dart';
import 'package:todo/tasks/todo.dart';

class TaskViewSet extends StatefulWidget {
  const TaskViewSet({super.key});

  @override
  State<TaskViewSet> createState() => _TaskViewSetState();
}

class _TaskViewSetState extends State<TaskViewSet> {
  int _index = 1;
  final List<Widget> views = [
    TodoPage(),
    DoingPage(),
    DonePage(),
    OnHoldPage(),
  ];

  Widget _getWidget(int index) {
    if (index > views.length - 1 || index < 0) {
      return views[0];
    }
    return views[index];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: _getWidget(_index),
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          Icon(Icons.list_alt, color: colorScheme.primary),
          Icon(Icons.autorenew, color: colorScheme.primary),
          Icon(Icons.check_circle, color: colorScheme.primary),
          Icon(Icons.pause_circle_filled, color: colorScheme.primary),
        ],
        index: _index,
        height: 55,
        maxWidth: 500,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 250),
        backgroundColor: Colors.transparent,
        color: colorScheme.inversePrimary,
        buttonBackgroundColor: colorScheme.inversePrimary,
        onTap: (selected) {
          setState(() {
            _index = selected;
          });
        },
      ),
    );
  }
}
