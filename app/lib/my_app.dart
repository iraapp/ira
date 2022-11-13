import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ira/firebase_options.dart';
import 'package:ira/screens/dashboard/dashboard.dart';
import 'package:ira/screens/dashboard/general_feed/panel_state_stream.dart';
import 'package:ira/services/auth.service.dart';
import 'package:ira/shared/alert_snackbar.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

void initAppWithFirebase() async {
  //Intialize firebase and firebase cloud messaging.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.subscribeToTopic('feed');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<ConnectivityResult> subscription;
  // ignore: avoid_init_to_null
  ConnectivityResult? previousState = null;
  bool firstConnection = true;
  final localStorage = LocalStorage('store');

  @override
  void initState() {
    super.initState();

    // Register licenses for google fonts.
    LicenseRegistry.addLicense(() async* {
      final license = await rootBundle.loadString('google_fonts/OFL.txt');
      yield LicenseEntryWithLineBreaks(['google_fonts'], license);
    });

    // Initialize connectivity status.
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (previousState == null) {
        previousState = result;
        return;
      }

      if (result == ConnectivityResult.none &&
          (previousState == ConnectivityResult.ethernet ||
              previousState == ConnectivityResult.mobile ||
              previousState == ConnectivityResult.wifi)) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(alertSnackbar(
          ''
          "No internet connection",
          Colors.red,
        ));
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(alertSnackbar(
          "Connected to internet",
          Colors.green,
        ));
      }

      previousState = result;
    });
  }

  @override
  void dispose() {
    super.dispose();

    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(context: context),
        ),
        ChangeNotifierProvider<PanelStateStream>(
            create: (_) => PanelStateStream())
      ],
      child: FlavorBanner(
        location: BannerLocation.topEnd,
        child: MaterialApp(
          title: 'IRA',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              textTheme: GoogleFonts.latoTextTheme(),
              listTileTheme: ListTileTheme.of(context).copyWith(
                selectedColor: Colors.blue,
              )),
          home: Dashboard(
            role: localStorage.getItem('role') ?? 'student',
          ),
        ),
      ),
    );
  }
}
