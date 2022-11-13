import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ira/constants/constants.dart';
import 'package:ira/screens/dashboard/dashboard.dart';
import 'package:localstorage/localstorage.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameFieldController = TextEditingController();
  TextEditingController passwordFieldController = TextEditingController();
  bool invalid = false;
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];
  final secureStorage = const FlutterSecureStorage();
  final localStorage = LocalStorage('store');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                'Welcome to',
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
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Username'),
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
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Password'),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),
              const SizedBox(
                height: 15.0,
              ),
              Text(
                invalid ? 'Invalid Username and password' : '',
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(
                height: 15.0,
              ),
              SizedBox(
                height: 50.0,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final response = await http.post(
                          Uri.parse(
                            baseUrl + '/auth/staff-token',
                          ),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: jsonEncode(<String, String>{
                            'username': usernameFieldController.text,
                            'password': passwordFieldController.text
                          }));

                      if (response.statusCode == 200) {
                        final staffRole = staffRoleChoices[
                            jsonDecode(response.body)['staff_user']['role']];
                        await secureStorage.write(
                          key: 'staffToken',
                          value: jsonDecode(response.body)['token'],
                        );
                        await localStorage.setItem(
                          'staffRole',
                          staffRole,
                        );
                        await localStorage.setItem(
                            'staffName',
                            jsonDecode(response.body)['staff_user']
                                    ['first_name'] +
                                ' ' +
                                jsonDecode(response.body)['staff_user']
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
                        setState(() {
                          invalid = true;
                        });
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
    );
  }
}
