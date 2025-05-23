import 'package:flutter/material.dart';
import 'package:todo/core/styles.dart';

class DonePage extends StatelessWidget {
  const DonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Done",
        style: CustomTextStyles.h1.copyWith(color: CustomColors.textColor),
      ),
    );
  }
}
