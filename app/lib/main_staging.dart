import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:ira/my_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

Future main() async {
  // Load environments variables from .env file.
  await dotenv.load(fileName: ".env.symlink");

  // Initialize the plugin for flutter downloader
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );

  FlavorConfig(
    name: "STAGING",
    color: Colors.blue,
    variables: {
      "baseUrl": dotenv.env['STAGING_MODE_BASELINK'],
      "mediaUrl": dotenv.env['STAGING_MODE_BASELINK']
    },
  );

  initAppWithFirebase();
}
