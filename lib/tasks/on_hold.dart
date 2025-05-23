import 'package:flutter/material.dart';
import 'package:todo/core/styles.dart';

class OnHoldPage extends StatelessWidget {
  const OnHoldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "On Hold",
        style: CustomTextStyles.h1.copyWith(color: CustomColors.textColor),
      ),
    );
  }
}
