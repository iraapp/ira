import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/dashboard/app_drawer.dart';
import 'package:ira/screens/dashboard/general_feed/general_feed.dart';
import 'package:ira/screens/dashboard/general_feed/panel_state_stream.dart';
import 'package:ira/screens/dashboard/guard_menu.dart';
import 'package:ira/screens/dashboard/mess_manager_menu.dart';
import 'package:ira/screens/dashboard/security_officer_menu.dart';
import 'package:ira/screens/dashboard/staff_header.dart';
import 'package:ira/screens/dashboard/student_menu.dart';
import 'package:ira/screens/dashboard/student_header.dart';
import 'package:ira/screens/login/login.dart';
import 'package:ira/util/helpers.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'medical_manager_menu.dart';

// ignore: must_be_immutable
class Dashboard extends StatefulWidget {
  String role;
  final secureStorage = const FlutterSecureStorage();
  final localStorage = LocalStorage('store');
  final baseUrl = FlavorConfig.instance.variables['baseUrl'];
  final mediaUrl = FlavorConfig.instance.variables['mediaUrl'];

  roleHeaderMap(role) {
    if (rolesThatCanBeAssignedToStudent.contains(role)) {
      return StudentHeader();
    }

    switch (role) {
      case 'guard':
        return StaffHeader();
      case 'mess_manager':
        return StaffHeader();
      case 'medical_manager':
        return StaffHeader();
      case 'security_officer':
        return StaffHeader();
    }

    return Container();
  }

  roleBasedMenu(context) {
    if (role == 'hostel_secretary') {
      return studentMenu(context, true);
    }

    if (rolesThatCanBeAssignedToStudent.contains(role)) {
      return studentMenu(context, false);
    }

    switch (role) {
      case 'guard':
        return guardMenu(context);
      case 'mess_manager':
        return messManagerMenu(context);
      case 'medical_manager':
        return medicalManagerMenu(context);
      case 'security_officer':
        return securityOfficerMenu(context);
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

      if (isRoleWithGoogleAuth(widget.role)) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    PanelStateStream panelState = Provider.of(context);

    return Scaffold(
        drawer: AppDrawer(role: widget.role),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          title: widget.roleHeaderMap(widget.role),
        ),
        body: SlidingUpPanel(
          minHeight: MediaQuery.of(context).size.height - 300,
          maxHeight: MediaQuery.of(context).size.height,
          parallaxEnabled: true,
          parallaxOffset: 1.0,
          onPanelOpened: () {
            panelState.state = true;
            panelState.heightChangeController.add(true);
          },
          onPanelClosed: () {
            panelState.state = false;
            panelState.heightChangeController.add(false);
          },
          panel: canShowGeneralFeed(widget.role)
              ? GeneralFeed(role: widget.role)
              : Container(),
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
                  decoration: isUserStudent(widget.role)
                      ? const BoxDecoration(
                          image: DecorationImage(
                            opacity: 0.5,
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              'https://theiraapp.s3.ap-south-1.amazonaws.com/media/images/release.png',
                            ),
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
