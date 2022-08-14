import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/dashboard/guard_menu.dart';
import 'package:ira/screens/dashboard/mess_manager_menu.dart';
import 'package:ira/screens/dashboard/staff_header.dart';
import 'package:ira/screens/dashboard/student_menu.dart';
import 'package:ira/screens/dashboard/student_header.dart';
import 'package:ira/screens/login/login.dart';
import 'package:ira/services/auth.service.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Dashboard extends StatefulWidget {
  String role;
  final secureStorage = const FlutterSecureStorage();
  final localStorage = LocalStorage('store');
  final roleHeaderMap = {
    'student': StudentHeader(),
    'guard': StaffHeader(),
    'mess_manager': StaffHeader(),
  };

  roleBasedMenu(context) {
    switch (role) {
      case 'student':
        return studentMenu(context);
      case 'guard':
        return guardMenu(context);
      case 'mess_manager':
        return messManagerMenu(context);
    }
    return const <Widget>[];
  }

  Dashboard({Key? key, required this.role}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    authCheck();
  }

  void authCheck() async {
    String? idToken = await widget.secureStorage.read(key: 'idToken');
    String? staffToken = await widget.secureStorage.read(key: 'staffToken');

    if (idToken == null) {
      if (staffToken != null) {
        String? staffRole = await widget.localStorage.getItem('staffRole');
        setState(() {
          widget.role = staffRole!;
        });
      }

      if (widget.role == 'student') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    } else {
      widget.role = 'student';
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF09c6f9),
        elevation: 0,
        leading: const Icon(Icons.menu),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: const Icon(Icons.notifications),
          )
        ],
      ),
      body: Column(children: [
        Container(
          height: 130.0,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Color(0xFF09c7f9),
          ),
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
            child: widget.roleHeaderMap[widget.role],
          ),
        ),
        Expanded(
          child: Container(
            color: const Color(0xFF09c7f9),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0xFFE5E5E5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 2),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: SizedBox(
                        height: 150.0,
                        child: GridView.count(
                          crossAxisCount: 4,
                          children: widget.roleBasedMenu(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        TextButton(
          child: const Text(
            'Sign Out',
            style: TextStyle(
              color: Color(0xff3a82fd),
            ),
          ),
          onPressed: () async {
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
        )
      ]),
    );
  }
}
