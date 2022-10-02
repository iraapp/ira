import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ira/screens/dashboard/dashboard.dart';
import 'package:ira/screens/dashboard/general_feed/panel_state_stream.dart';
import 'package:ira/services/auth.service.dart';
import 'package:ira/shared/alert_snackbar.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
          title: 'Institute App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              textTheme: GoogleFonts.latoTextTheme(),
              listTileTheme: ListTileTheme.of(context).copyWith(
                selectedColor: Colors.blue,
              )),
          home: const Wrapper(),
        ),
      ),
    );
  }
}

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late StreamSubscription<ConnectivityResult> subscription;
  // ignore: avoid_init_to_null
  ConnectivityResult? previousState = null;
  bool firstConnection = true;

  @override
  void initState() {
    super.initState();

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
    return Dashboard(role: 'student');
  }
}
