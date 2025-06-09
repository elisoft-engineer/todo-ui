import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:todo/auth/signin_page.dart';
import 'package:todo/core/notifiers.dart';
import 'package:todo/tasks/main.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeModeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'Todo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: themeMode,
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
      },
    );
  }
}
