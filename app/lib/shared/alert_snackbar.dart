import 'package:flutter/material.dart';

SnackBar alertSnackbar(String message, MaterialColor backgroundColor) {
  return SnackBar(
    backgroundColor: backgroundColor,
    padding: const EdgeInsets.all(20),
    content: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  );
}
