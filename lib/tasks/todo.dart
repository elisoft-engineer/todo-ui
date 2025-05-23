import 'package:flutter/material.dart';
import 'package:todo/core/styles.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Todo",
        style: CustomTextStyles.h1.copyWith(color: CustomColors.textColor),
      ),
    );
  }
}
