import 'package:flutter/material.dart';

const SnackBar alertSnackbar = SnackBar(
  backgroundColor: Colors.red,
  padding: EdgeInsets.all(20),
  content: Text(
    "Failed to communicate with the servers",
    style: TextStyle(
      color: Colors.white,
    ),
  ),
);
