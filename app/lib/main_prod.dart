import 'package:flutter/material.dart';
import 'package:ira/my_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

Future main() async {
  // Load environments variables from .env file.
  await dotenv.load(fileName: ".env.symlink");

  FlavorConfig(
    name: "PROD",
    color: Colors.green,
    variables: {
      "baseUrl": dotenv.env['PROD_MODE_BASELINK'],
      "mediaUrl": '',
    },
  );

  initAppWithFirebase();
}
