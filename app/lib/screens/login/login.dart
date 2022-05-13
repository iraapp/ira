import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:institute_app/screens/dashboard/dashboard.dart';
import 'package:institute_app/screens/guard/guard_login.dart';
import 'package:institute_app/services/auth.service.dart';
import 'package:institute_app/util/helpers.dart';
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

    return Scaffold(
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff3a82fd),
                  Color(0xff5077d3),
                  Color(0xff3c91c8),
                  Color(0xff72a8ee),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(60, 20),
                bottomRight: Radius.elliptical(60, 20),
              )),
        ),
        Padding(
          padding: EdgeInsets.only(top: getHeightOf(context) * 0.15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/iit-jammu-logo-white.png',
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 50.0),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                          offset: Offset(
                            0,
                            5,
                          ))
                    ]),
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
                        'Institute App',
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
                        height: 30.0,
                      )
                    ],
                  ),
                ),
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
                        builder: (context) => const GuardLogin(),
                      ),
                    );
                  },
                  child: const Text(
                    'Continue as a Guard',
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
      ]),
    );
  }
}
