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
                                        baseUrl + '/auth/staff-token',
                                      ),
                                      headers: <String, String>{
                                        'Content-Type':
                                            'application/json; charset=UTF-8',
                                      },
                                      body: jsonEncode(<String, String>{
                                        'username':
                                            usernameFieldController.text,
                                        'password': passwordFieldController.text
                                      }));

                                  if (response.statusCode == 200) {
                                    await secureStorage.write(
                                      key: 'staffToken',
                                      value: jsonDecode(response.body)['token'],
                                    );
                                    await localStorage.setItem(
                                      'staffRole',
                                      staffRoleChoices[jsonDecode(
                                          response.body)['staff_user']['role']],
                                    );
                                    await localStorage.setItem(
                                        'staffName',
                                        jsonDecode(response.body)['staff_user']
                                                ['first_name'] +
                                            ' ' +
                                            jsonDecode(response.body)[
                                                'staff_user']['last_name']);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Dashboard(
                                          role: 'guard',
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
          );
        } else {
          return Dashboard(role: 'guard');
        }
      },
    );
  }
}
