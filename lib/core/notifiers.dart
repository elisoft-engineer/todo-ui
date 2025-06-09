import 'package:flutter/material.dart';
import 'package:todo/tasks/models.dart';

final ValueNotifier<Brightness> themeModeNotifier = ValueNotifier(
  Brightness.light,
);
final ValueNotifier<Future<List<Task>>> tasksFutureNotifier =
    ValueNotifier<Future<List<Task>>>(Future.value([]));
