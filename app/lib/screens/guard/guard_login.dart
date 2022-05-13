import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:institute_app/screens/dashboard/dashboard.dart';

class GuardLogin extends StatefulWidget {
  const GuardLogin({Key? key}) : super(key: key);

  @override
  State<GuardLogin> createState() => _GuardLoginState();
}

class _GuardLoginState extends State<GuardLogin> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameFieldController = TextEditingController();
  TextEditingController passwordFieldController = TextEditingController();
  // Create secureStorage
  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  Future<String> autoLogin() async {
    String? guardToken = await secureStorage.read(key: 'guardToken');

    final response = await http.get(
        Uri.parse(
          baseUrl + '/auth/login',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': guardToken != null ? 'Token ' + guardToken : ''
        });

    if (response.statusCode == 200) {
      return Future.value(guardToken);
    } else {
      return Future.value('invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: autoLogin(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.data == 'invalid') {
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
                padding: const EdgeInsets.only(top: 80.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 50.0),
                        width: MediaQuery.of(context).size.width * 0.9,
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
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                const SizedBox(height: 10.0),
                                TextFormField(
                                  controller: usernameFieldController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Username field cannot be empty';
                                    }

                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Username'),
                                ),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                TextFormField(
                                  controller: passwordFieldController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password field cannot be empty';
                                    }

                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Password'),
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                ),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      final response = await http.post(
                                          Uri.parse(
                                            baseUrl + '/auth/guard-token',
                                          ),
                                          headers: <String, String>{
                                            'Content-Type':
                                                'application/json; charset=UTF-8',
                                          },
                                          body: jsonEncode(<String, String>{
                                            'username':
                                                usernameFieldController.text,
                                            'password':
                                                passwordFieldController.text
                                          }));

                                      if (response.statusCode == 200) {
                                        await secureStorage.write(
                                          key: 'guardToken',
                                          value: jsonDecode(
                                              response.body)['token'],
                                        );
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Dashboard(
                                              role: 'guard',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: const Text('Log in'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                  ],
                ),
              ),
            ]),
          );
        } else {
          return Dashboard(role: 'guard');
        }
      },
    );
  }
}
