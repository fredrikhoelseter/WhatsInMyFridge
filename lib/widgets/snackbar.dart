import 'package:flutter/material.dart';
//This class has been borrowed from: https://github.com/dev-tayy/fuzzy-eureka/blob/master/lib/components/snackbar.dart

class CustomSnackBar {
  static showSuccessSnackBar(BuildContext context,
      {required String message,
      int milliseconds = 10000,
      SnackBarBehavior snackBarBehavior = SnackBarBehavior.floating}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        margin: const EdgeInsets.only(bottom: 100.0),
        behavior: snackBarBehavior,
        action: SnackBarAction(
            textColor: Colors.white,
            label: 'DISMISS',
            onPressed: () => _dismissCurrentSnackBar(context)),
        duration: Duration(milliseconds: milliseconds),
        content: SelectableText(
          message,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context,
      {String? message,
      int milliseconds = 5000,
      SnackBarBehavior snackBarBehavior = SnackBarBehavior.floating}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color.fromARGB(255, 180, 0, 27),
        behavior: snackBarBehavior,
        action: SnackBarAction(
            textColor: Color.fromARGB(255, 255, 255, 255),
            label: 'DISMISS',
            onPressed: () => _dismissCurrentSnackBar(context)),
        duration: Duration(milliseconds: milliseconds),
        content: SelectableText(
          message ?? 'An error occured',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  static void _dismissCurrentSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
