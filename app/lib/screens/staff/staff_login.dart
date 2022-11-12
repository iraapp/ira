import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ira/screens/dashboard/dashboard.dart';
import 'package:ira/screens/staff/login_form.dart';
import 'package:ira/shared/app_scaffold.dart';

class StaffLogin extends StatefulWidget {
  const StaffLogin({Key? key}) : super(key: key);

  @override
  State<StaffLogin> createState() => _StaffLoginState();
}

class _StaffLoginState extends State<StaffLogin> {
  // Create secureStorage
  final secureStorage = const FlutterSecureStorage();
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
                  const SizedBox(height: 80.0),
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
                      ),
                      child: const LoginForm(),
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
