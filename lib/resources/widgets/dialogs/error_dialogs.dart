import 'package:flutter/material.dart';

class ErrorDialogs {
  static show(
    BuildContext context, {
    required String errorMessage,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
        content: Text(errorMessage),
        title: const Text('Error'),
      ),
    );
  }
}
