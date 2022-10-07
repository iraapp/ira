import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ira/constants/constants.dart';
import 'package:ira/screens/dashboard/dashboard.dart';
import 'package:ira/shared/app_scaffold.dart';
import 'package:localstorage/localstorage.dart';

class StaffLogin extends StatefulWidget {
  const StaffLogin({Key? key}) : super(key: key);

  @override
  State<StaffLogin> createState() => _StaffLoginState();
}

class _StaffLoginState extends State<StaffLogin> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameFieldController = TextEditingController();
  TextEditingController passwordFieldController = TextEditingController();
  // Create secureStorage
  final secureStorage = const FlutterSecureStorage();
  final localStorage = LocalStorage('store');
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  Future<String> autoLogin() async {
    String? staffToken = await secureStorage.read(key: 'staffToken');

    final response = await http.get(
        Uri.parse(
          baseUrl + '/auth/login',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': staffToken != null ? 'Token ' + staffToken : ''
        });

    if (response.statusCode == 200) {
      return Future.value(staffToken);
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 20.0),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20.0,
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
                                TextFormField(
                                  controller: usernameFieldController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Username field cannot be empty';
                                    }

                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      hintText: 'Username'),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  controller: passwordFieldController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password field cannot be empty';
                                    }

                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      hintText: 'Password'),
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                ),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                SizedBox(
                                  height: 50.0,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ))),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        final response = await http.post(
                                            Uri.parse(
                                              baseUrl + '/auth/staff-token',
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
                                          final staffRole = staffRoleChoices[
                                              jsonDecode(response.body)[
                                                  'staff_user']['role']];
                                          await secureStorage.write(
                                            key: 'staffToken',
                                            value: jsonDecode(
                                                response.body)['token'],
                                          );
                                          await localStorage.setItem(
                                            'staffRole',
                                            staffRole,
                                          );
                                          await localStorage.setItem(
                                              'staffName',
                                              jsonDecode(response.body)[
                                                          'staff_user']
                                                      ['first_name'] +
                                                  ' ' +
                                                  jsonDecode(response.body)[
                                                          'staff_user']
                                                      ['last_name']);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Dashboard(
                                                role: staffRole ?? '',
                                              ),
                                            ),
                                          );
                                        } else {
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(alertSnackbar);
                                        }
                                      }
                                    },
                                    child: const Text('Log in'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Dashboard(role: 'guard');
          }
        });
  }
}
