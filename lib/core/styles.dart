import 'package:flutter/material.dart';

class CustomColors {
  static const primaryColor = Color(0xFF4DDF13);
  static const background = Color(0xffffffff);
  static const textColor = Color(0xff252525);
  static const error = Color(0xBAFF0000);
  static const success = Color(0xB909FF00);
}

class CustomTextStyles {
  static const h1 = TextStyle(fontSize: 40, fontWeight: FontWeight.w900);
  static const h2 = TextStyle(fontSize: 32, fontWeight: FontWeight.w700);
  static const h3 = TextStyle(fontSize: 25, fontWeight: FontWeight.w600);

  static const b1 = TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
  static const b2 = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static const b3 = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);

  static const s1 = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
  static const s2 = TextStyle(fontSize: 12, fontWeight: FontWeight.w400);
  static const s3 = TextStyle(fontSize: 10, fontWeight: FontWeight.w400);
}

const customInputDecoration = InputDecoration(
  filled: true,
  fillColor: CustomColors.background,
  border: OutlineInputBorder(
    borderSide: BorderSide(color: CustomColors.textColor),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: CustomColors.textColor),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: CustomColors.textColor),
  ),
);
