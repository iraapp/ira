import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ira/screens/dashboard/dashboard.dart';
import 'package:ira/screens/login/welcome/welcome.dart';
import 'package:ira/screens/staff/staff_login.dart';
import 'package:ira/services/auth.service.dart';
import 'package:ira/shared/app_scaffold.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final localStorage = LocalStorage('store');
  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of(context);

    return AppScaffold(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const SizedBox(height: 80.0),
        Center(
          child: Image.asset(
            'assets/images/iit-jammu-logo-white.png',
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 50.0),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 40.0,
                  ),
                  const Text(
                    'Welcome to ',
                    style: TextStyle(fontSize: 22),
                  ),
                  const Text(
                    'IRA',
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  const Text(
                    'Login using your institute id',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  IconButton(
                    iconSize: 55.0,
                    icon: SvgPicture.asset(
                      'assets/svgs/google_sign_in.svg',
                    ),
                    onPressed: () async {
                      authService.successCallback =
                          (bool askForDetails, String role) async {
                        if (askForDetails) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WelcomeScreen(),
                            ),
                          );
                        } else {
                          String? idToken =
                              await secureStorage.read(key: 'idToken');
                          final response = await http.get(
                              Uri.parse(
                                baseUrl + '/user_profile/contact',
                              ),
                              headers: <String, String>{
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                                'Authorization': 'idToken ' + idToken!
                              });

                          if (response.statusCode == 200) {
                            String decodedBody = jsonDecode(response.body);
                            localStorage.setItem('contact', decodedBody);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Dashboard(
                                  role: role,
                                ),
                              ),
                            );
                          }
                        }
                      };
                      await authService.signIn();
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StaffLogin(),
                          ),
                        );
                      },
                      child: const Text(
                        'Continue as Staff',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
