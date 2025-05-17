import 'package:flutter/material.dart';
import 'package:todo/components/app_bar.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key, required this.title});
  final String title;

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  Future<void> signin() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: "Sign In"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
