import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:institute_app/screens/dashboard/dashboard.dart';
import 'package:institute_app/screens/login/login.dart';
import 'package:institute_app/services/auth.service.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(),
        )
      ],
      child: FlavorBanner(
        location: BannerLocation.topEnd,
        child: const MaterialApp(
          title: 'Institute App',
          debugShowCheckedModeBanner: false,
          home: Wrapper(),
        ),
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dashboard(role: 'student');
  }
}
