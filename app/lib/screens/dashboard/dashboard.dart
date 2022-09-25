import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/dashboard/app_drawer.dart';
import 'package:ira/screens/dashboard/general_feed/general_feed.dart';
import 'package:ira/screens/dashboard/guard_menu.dart';
import 'package:ira/screens/dashboard/mess_manager_menu.dart';
import 'package:ira/screens/dashboard/staff_header.dart';
import 'package:ira/screens/dashboard/student_menu.dart';
import 'package:ira/screens/dashboard/student_header.dart';
import 'package:ira/screens/login/login.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'medical_manager_menu.dart';

// ignore: must_be_immutable
class Dashboard extends StatefulWidget {
  String role;
  final secureStorage = const FlutterSecureStorage();
  final localStorage = LocalStorage('store');
  final baseUrl = FlavorConfig.instance.variables['baseUrl'];

  final roleHeaderMap = {
    'student': StudentHeader(),
    'guard': StaffHeader(),
    'mess_manager': StaffHeader(),
    'medical_manager': StaffHeader(),
  };

  roleBasedMenu(context) {
    switch (role) {
      case 'student':
        return studentMenu(context);
      case 'guard':
        return guardMenu(context);
      case 'mess_manager':
        return messManagerMenu(context);
      case 'medical_manager':
        return medicalManagerMenu(context);
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
    return Scaffold(
        drawer: AppDrawer(role: widget.role),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          title: widget.roleHeaderMap[widget.role],
        ),
        body: SlidingUpPanel(
          minHeight: MediaQuery.of(context).size.height - 280,
          maxHeight: MediaQuery.of(context).size.height,
          parallaxEnabled: true,
          parallaxOffset: 1.0,
          panel: widget.role == 'student' ? const GeneralFeed() : Container(),
          body: Container(
            // color: Colors.blue,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: widget.role == 'student'
                      ? BoxDecoration(
                          image: DecorationImage(
                            opacity: 0.5,
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                widget.baseUrl + '/media/images/release.png'),
                          ),
                        )
                      : const BoxDecoration(),
                  child: SizedBox(
                    height: 180.0,
                    child: GridView.count(
                      crossAxisCount: 4,
                      children: widget.roleBasedMenu(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
