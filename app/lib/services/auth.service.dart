import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ira/constants/constants.dart';
import 'package:localstorage/localstorage.dart';

class AuthService with ChangeNotifier {
  GoogleSignInAccount? _user;
  bool isAuthenticated = false;
  final GoogleSignIn _googleSignIn =
      GoogleSignIn(serverClientId: dotenv.env['GOOGLE_OAUTH_CLIENT_ID']);
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];
  // ignore: prefer_function_declarations_over_variables
  var successCallback = (bool askForDetails, String role) async {};

  // Create secureStorage
  final secureStorage = const FlutterSecureStorage();
  final localStorage = LocalStorage('store');

  BuildContext context;

  AuthService({required this.context}) {
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      if (account != null) {
        if (account.email.split('@')[1] != 'iitjammu.ac.in') {
          await _googleSignIn.signOut();
        }

        _user = account;
        _user?.authentication.then(
          (googleKey) async {
            final response = await http.post(
                Uri.parse(
                  baseUrl + '/auth/login',
                ),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode({
                  'idToken': googleKey.idToken,
                }));

            if (response.statusCode == 200) {
              isAuthenticated = true;
              await secureStorage.write(
                key: 'idToken',
                value: jsonDecode(response.body)['idToken'],
              );

              String role =
                  userRoles[jsonDecode(response.body)['user']['role']] ??
                      'student';
              await localStorage.setItem('role', role);

              localStorage.setItem('displayName', _user?.displayName);
              localStorage.setItem('email', _user?.email);

              bool askForDetails = jsonDecode(response.body)['askForDetails'];

              await successCallback(askForDetails, role);
            } else {
              // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
            }
          },
        ).catchError((err) {
          isAuthenticated = false;
        });
      } else {
        isAuthenticated = false;
      }
    });

    _googleSignIn.signInSilently();
  }

  GoogleSignInAccount? get user {
    return _user;
  }

  signIn() async {
    await _googleSignIn.signIn();
  }

  signOut() async {
    await _googleSignIn.signOut();
    await secureStorage.delete(key: 'idToken');
    await secureStorage.delete(key: 'role');
  }
}
