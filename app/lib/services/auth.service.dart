import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  GoogleSignInAccount? _user;
  bool isAuthenticated = false;
  StreamController<bool> isAuthenticatedStreamController =
      StreamController<bool>();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId:
          '776874295259-53ophl75eqo7l0bfgad108p7nm75do1i.apps.googleusercontent.com');
  // Create storage
  final storage = const FlutterSecureStorage();

  AuthService() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account != null) {
        _user = account;
        _user?.authentication.then(
          (googleKey) async {
            final response = await http.get(
              Uri.parse('http://172.19.138.240:8000/auth/login'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'idToken ' + googleKey.idToken!
              },
            );

            if (response.statusCode == 200) {
              print('Successfully authenticated with backend');
              isAuthenticated = true;
              await storage.write(
                key: 'idToken',
                value: googleKey.idToken,
              );
              isAuthenticatedStreamController.add(isAuthenticated);
              notifyListeners();
            }
          },
        ).catchError((err) {
          isAuthenticated = false;
          isAuthenticatedStreamController.add(isAuthenticated);
          print(err);
          print('authentication failed');
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
  }
}
