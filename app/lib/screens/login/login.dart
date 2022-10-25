import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ira/screens/dashboard/dashboard.dart';
import 'package:ira/screens/staff/staff_login.dart';
import 'package:ira/services/auth.service.dart';
import 'package:ira/shared/app_scaffold.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of(context);

    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40.0),
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
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
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
                      'Welcome to the',
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
                      'Login using your Gmail id',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    IconButton(
                      iconSize: 60.0,
                      icon: SvgPicture.asset(
                        'assets/svgs/google_sign_in.svg',
                      ),
                      onPressed: () async {
                        authService.successCallback = () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Dashboard(
                                role: 'student',
                              ),
                            ),
                          );
                          authService.successCallback = () {};
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
                          'Continue as a Staff',
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
        ],
      ),
    );
  }
}
