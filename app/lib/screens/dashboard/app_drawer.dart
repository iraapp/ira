import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/dashboard/student_drawer_header.dart';
import 'package:ira/screens/gate_pass/purpose.dart';
import 'package:ira/screens/hostel/dashboard.dart';
import 'package:ira/screens/login/login.dart';
import 'package:ira/screens/medical/dashboard.dart';
import 'package:ira/screens/mess/student/mess_student.dart';
import 'package:ira/screens/team/team.dart';
import 'package:ira/services/auth.service.dart';
import 'package:ira/util/helpers.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool disableDrawerTiles = false;

  Future<void> _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      throw 'Could not launch $_url';
    }
  }

  @override
  void initState() {
    super.initState();

    disableDrawerTiles = !isUserStudent(widget.role);
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of(context);

    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        isUserStudent(widget.role) ? StudentDrawerHeader() : Container(),
        const Divider(),
        ListTile(
          leading: const Icon(
            Icons.home,
          ),
          selected: true,
          title: const Text(
            "Home",
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.apartment),
          title: const Text("Hostel"),
          enabled: !disableDrawerTiles,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HostelStudentScreen(),
                ));
          },
        ),
        ListTile(
          leading: const Icon(Icons.fastfood),
          title: const Text("Mess"),
          enabled: !disableDrawerTiles,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MessStudentScreen(),
                ));
          },
        ),
        ListTile(
          leading: const Icon(Icons.medical_services),
          title: const Text("Medical"),
          enabled: !disableDrawerTiles,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MedicalStudentScreen(),
                ));
          },
        ),
        // ListTile(
        //   leading: const Icon(Icons.person),
        //   title: const Text("Id Card"),
        //   enabled: !disableDrawerTiles,
        //   onTap: () {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => Profile(),
        //         ));
        //   },
        // ),
        ListTile(
          leading: const Icon(Icons.sensor_door),
          title: const Text("Gate Pass"),
          enabled: !disableDrawerTiles,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PurposeScreen(),
                ));
          },
        ),
        ListTile(
          leading: const Icon(Icons.groups),
          title: const Text("Team"),
          enabled: !disableDrawerTiles,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TeamScreen(),
                ));
          },
        ),
        ListTile(
          leading: const Icon(Icons.forum),
          title: const Text("Feedback"),
          enabled: !disableDrawerTiles,
          onTap: () {
            _launchUrl(
                'mailto:ira.app@iitjammu.ac.in?subject=IRA App Feedback');
          },
        ),
        ListTile(
          hoverColor: Colors.blue,
          leading: const Icon(Icons.logout),
          title: const Text('Sign out'),
          onTap: () async {
            if (isRoleWithGoogleAuth(widget.role)) {
              await authService.signOut();
            } else {
              await widget.secureStorage.delete(key: 'staffToken');
              await widget.localStorage.deleteItem('staffRole');
              await widget.localStorage.deleteItem('staffName');
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
