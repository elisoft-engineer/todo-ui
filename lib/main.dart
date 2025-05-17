import 'package:flutter/material.dart';
import 'package:todo/auth/signin_page.dart';

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
      routes: {'/': (context) => SigninPage(title: "Sign In")},
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
