import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ira/screens/dashboard/dashboard.dart';
import 'package:ira/screens/login/welcome/welcome.dart';
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
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50.0),
            Center(
              child: Image.asset(
                'assets/images/iit-jammu-logo-white.png',
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 50.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Welcome to the',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      const Text(
                        'IRA',
                        style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 80.0,
                      ),
                      const Text(
                        'Login using your gmail',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      IconButton(
                        iconSize: 50.0,
                        icon: SvgPicture.asset(
                          'assets/svgs/login_with_google.svg',
                        ),
                        onPressed: () async {
                          authService.successCallback = (bool askForDetails) {
                            if (askForDetails) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WelcomeScreen(),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Dashboard(
                                    role: 'student',
                                  ),
                                ),
                              );
                            }
                          };
                          await authService.signIn();
                        },
                      ),
                      const SizedBox(
                        height: 15.0,
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
                              fontSize: 15.0,
                              color: Color(0xff4486cc),
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
      ),
    );
  }
}
