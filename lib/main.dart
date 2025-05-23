import 'package:flutter/material.dart';
import 'package:todo/auth/signin_page.dart';
import 'package:todo/tasks/main.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 0, 255),
        ),
        fontFamily: "Urbanist",
      ),
      routes: {
        'signin': (context) => SigninPage(title: "Sign In"),
        'tasks': (context) => TaskViewSet(),
      },
      initialRoute: 'signin',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
    );
  }
}
