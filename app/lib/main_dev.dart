import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    name: "DEV",
    color: Colors.red,
    variables: {
      "baseUrl": dotenv.env['DEV_MODE_BASELINK'],
    },
  );

  // Register licenses for google fonts.
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  runApp(const MyApp());
}
