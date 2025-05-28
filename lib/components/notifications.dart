import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CustomNotifications {
  static void showSuccess(BuildContext context, String message) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(
        message: message,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        iconPositionLeft: 10,
        iconRotationAngle: 15,
      ),
      padding: EdgeInsets.all(5),
    );
  }

  static void showError(BuildContext context, String message) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: message,
        icon: const Icon(Icons.error, color: Colors.white),
        iconPositionLeft: 10,
        iconRotationAngle: 15,
      ),
    );
  }

  static void showInfo(BuildContext context, String message) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.info(
        message: message,
        icon: const Icon(Icons.question_mark, color: Colors.white),
        iconPositionLeft: 10,
        iconRotationAngle: 15,
      ),
    );
  }
}
