import 'package:flutter/material.dart';
import 'package:todo/auth/signin_page.dart';
import 'package:todo/tasks/todo.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF21DB08)),
        fontFamily: "Urbanist",
      ),
      routes: {
        'signin': (context) => SigninPage(title: "Sign In"),
        'todo': (context) => TodoPage(),
      },
      initialRoute: 'signin',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
    );
  }
}
