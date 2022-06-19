import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/dashboard/components/menu_item.dart';
import 'package:ira/screens/gate_pass/purpose.dart';
import 'package:ira/screens/login/login.dart';
import 'package:ira/screens/mess/mess.dart';
import 'package:ira/services/auth.service.dart';
import 'package:ira/shared/app_scaffold.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import '../../util/helpers.dart';
import '../gate_pass/scan_gate_pass.dart';
import '../profile/profile.dart';

String capitalize(String str) {
  return '${str[0].toUpperCase()}${str.substring(1).toLowerCase()}';
}

class Username extends StatelessWidget {
  Username({Key? key}) : super(key: key);
  final localStorage = LocalStorage('store');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: localStorage.ready,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return const Text('');
          }

          if (localStorage.getItem('displayName') == null) {
            return const Text('');
          }

          String displayName = localStorage.getItem('displayName');
          return Text(
            capitalize(displayName.split(' ')[0]) +
                ' ' +
                capitalize(displayName.split(' ')[1]),
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          );
        });
  }
}

// ignore: must_be_immutable
class Dashboard extends StatefulWidget {
  String role;
  final secureStorage = const FlutterSecureStorage();

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
    String? guardToken = await widget.secureStorage.read(key: 'guardToken');

    if (idToken == null) {
      if (guardToken != null) {
        setState(() {
          widget.role = 'guard';
        });
      }

      if (widget.role == 'student') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of(context);

    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: getHeightOf(context) * 0.05),
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                      offset: Offset(
                        0,
                        5,
                      ))
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: <Widget>[
                  const Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  widget.role != 'guard'
                      ? Username()
                      : const Text('Guard user'),
                  const SizedBox(
                    height: 20.0,
                  ),
                  widget.role != 'guard'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MenuItem(
                              fade: false,
                              iconData: Icons.person,
                              menuName: 'Digital ID Card',
                              pressHandler: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Profile()));
                              },
                            ),
                            MenuItem(
                              fade: true,
                              iconData: Icons.apartment_rounded,
                              menuName: 'Hostel',
                              pressHandler: () {},
                            ),
                          ],
                        )
                      : Container(),
                  widget.role != 'guard'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MenuItem(
                              fade: false,
                              iconData: Icons.food_bank,
                              menuName: 'Mess',
                              pressHandler: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MessScreen()));
                              },
                            ),
                            MenuItem(
                              fade: true,
                              iconData: Icons.medical_services_rounded,
                              menuName: 'Medical',
                              pressHandler: () {},
                            ),
                          ],
                        )
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.role != 'guard'
                          ? MenuItem(
                              fade: false,
                              iconData: Icons.admin_panel_settings_rounded,
                              menuName: 'Gate Pass',
                              pressHandler: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PurposeScreen(),
                                    ));
                              },
                            )
                          : MenuItem(
                              fade: false,
                              iconData: Icons.admin_panel_settings_rounded,
                              menuName: 'Scan Gate Pass',
                              pressHandler: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ScanGatePass(),
                                    ));
                              },
                            ),
                    ],
                  )
                ]),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextButton(
            child: Text(
              'Sign Out',
              style: TextStyle(
                color: widget.role != 'guard'
                    ? const Color(0xff3a82fd)
                    : Colors.white,
              ),
            ),
            onPressed: () async {
              if (widget.role == 'guard') {
                await widget.secureStorage.delete(key: 'guardToken');
              } else {
                await authService.signOut();
              }
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
