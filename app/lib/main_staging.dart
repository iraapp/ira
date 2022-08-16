import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:ira/my_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

Future main() async {
  // Initialize the plugin for flutter downloader
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );
  // Load environments variables from .env file.
  await dotenv.load(fileName: ".env.symlink");

  FlavorConfig(
    name: "STAGING",
    color: Colors.blue,
    variables: {
      "baseUrl": dotenv.env['STAGING_MODE_BASELINK'],
    },
  );

  runApp(const MyApp());
}
