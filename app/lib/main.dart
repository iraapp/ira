import 'package:flutter/material.dart';
import 'package:institute_app/screens/dashboard/dashboard.dart';
import 'package:institute_app/screens/login/login.dart';
import 'package:institute_app/services/auth.service.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      MultiProvider(
        // create: (context) => UserModel(),
        providers: [
          ChangeNotifierProvider<AuthService>(
            create: (_) => AuthService(),
          )
        ],
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Institute App',
      home: Wrapper(),
    );
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of(context);

    return StreamBuilder(
      stream: authService.isAuthenticatedStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return const Dashboard(
            role: 'student',
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
