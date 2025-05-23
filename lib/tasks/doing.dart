import 'package:flutter/material.dart';
import 'package:todo/core/styles.dart';

class DoingPage extends StatelessWidget {
  const DoingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Doing",
        style: CustomTextStyles.h1.copyWith(color: CustomColors.textColor),
      ),
    );
  }
}
