import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart';

class AuthService with ChangeNotifier {
  GoogleSignInAccount? _user;
  bool isAuthenticated = false;
  StreamController<bool> isAuthenticatedStreamController =
      StreamController<bool>();
  final GoogleSignIn _googleSignIn =
      GoogleSignIn(clientId: dotenv.env['GOOGLE_OAUTH_CLIENT_ID']);
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];
  // ignore: prefer_function_declarations_over_variables
  VoidCallback successCallback = () {};

  // Create secureStorage
  final secureStorage = const FlutterSecureStorage();
  final localStorage = LocalStorage('store');

  AuthService() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account != null) {
        _user = account;
        _user?.authentication.then(
          (googleKey) async {
            final response = await http.get(
              Uri.parse(
                baseUrl + '/auth/login',
              ),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'idToken ' + googleKey.idToken!
              },
            );

            if (response.statusCode == 200) {
              isAuthenticated = true;
              await secureStorage.write(
                key: 'idToken',
                value: googleKey.idToken,
              );

              localStorage.setItem('displayName', _user?.displayName);

              isAuthenticatedStreamController.add(isAuthenticated);
              notifyListeners();
              successCallback();
            }
          },
        ).catchError((err) {
          isAuthenticated = false;
          isAuthenticatedStreamController.add(isAuthenticated);
        });
      } else {
        isAuthenticated = false;
        isAuthenticatedStreamController.add(isAuthenticated);
        notifyListeners();
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
  }
}
