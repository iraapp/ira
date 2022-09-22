import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/dashboard/student_drawer_header.dart';
import 'package:ira/screens/login/login.dart';
import 'package:ira/services/auth.service.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AppDrawer extends StatefulWidget {
  String role;
  final secureStorage = const FlutterSecureStorage();
  final localStorage = LocalStorage('store');

  AppDrawer({Key? key, required this.role}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of(context);

    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        StudentDrawerHeader(),
        const Divider(),
        const ListTile(
          leading: Icon(
            Icons.home,
          ),
          title: Text(
            "Home",
          ),
        ),
        const ListTile(
          leading: Icon(Icons.person),
          title: Text("Hostel"),
        ),
        const ListTile(
          leading: Icon(Icons.food_bank),
          title: Text("Mess"),
        ),
        const ListTile(
          leading: Icon(Icons.medical_services),
          title: Text("Medical"),
        ),
        const ListTile(
          leading: Icon(Icons.people),
          title: Text("Team"),
        ),
        ListTile(
          hoverColor: Colors.blue,
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Sign out'),
          onTap: () async {
            if (widget.role == 'student') {
              await authService.signOut();
            } else {
              await widget.secureStorage.delete(key: 'staffToken');
              await widget.secureStorage.delete(key: 'role');
            }
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
        ),
      ],
    ));
  }
}
