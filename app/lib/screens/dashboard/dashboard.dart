import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ira/screens/dashboard/components/menu_item.dart';
import 'package:ira/screens/gate_pass/purpose.dart';
import 'package:ira/screens/login/login.dart';
import 'package:ira/screens/mess/mess.dart';
import 'package:ira/screens/team/team.dart';
import 'package:ira/services/auth.service.dart';
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
          String entry = localStorage.getItem('entry');
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                capitalize(displayName.split(' ')[0]) +
                    ' ' +
                    capitalize(displayName.split(' ')[1]),
                style: const TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                entry.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
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
            child: Username(),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFF09C7F9),
                              child: IconButton(
                                icon: const Icon(Icons.person),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Profile(),
                                    ),
                                  );
                                },
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            const Text(
                              "Id Card",
                              style: TextStyle(fontSize: 12.0),
                            )
                          ]),
                          Column(children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFF09C7F9),
                              child: IconButton(
                                icon: const Icon(Icons.food_bank),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MessScreen(),
                                    ),
                                  );
                                },
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            const Text(
                              "Mess",
                              style: TextStyle(fontSize: 12.0),
                            )
                          ]),
                          Column(children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFF09C7F9),
                              child: IconButton(
                                icon: const Icon(
                                    Icons.admin_panel_settings_rounded),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PurposeScreen(),
                                    ),
                                  );
                                },
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            const Text(
                              "Gate Pass",
                              style: TextStyle(fontSize: 12.0),
                            )
                          ]),
                          Column(children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFF09C7F9),
                              child: IconButton(
                                icon: const Icon(Icons.people),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const TeamScreen(),
                                    ),
                                  );
                                },
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            const Text(
                              "Team",
                              style: TextStyle(fontSize: 12.0),
                            )
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );

    // return AppScaffold(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Center(
    //         child: Container(
    //           margin: EdgeInsets.only(top: getHeightOf(context) * 0.05),
    //           width: MediaQuery.of(context).size.width * 0.9,
    //           decoration: BoxDecoration(
    //             color: Colors.white,
    //             borderRadius: BorderRadius.circular(10),
    //             boxShadow: const [
    //               BoxShadow(
    //                   color: Colors.grey,
    //                   blurRadius: 5.0,
    //                   offset: Offset(
    //                     0,
    //                     5,
    //                   ))
    //             ],
    //           ),
    //           child: Padding(
    //             padding: const EdgeInsets.all(20.0),
    //             child: Column(children: <Widget>[
    //               const Text(
    //                 'Welcome back',
    //                 style: TextStyle(
    //                   fontSize: 18.0,
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 5.0,
    //               ),
    //               widget.role != 'guard'
    //                   ? Username()
    //                   : const Text('Guard user'),
    //               const SizedBox(
    //                 height: 20.0,
    //               ),
    //               widget.role != 'guard'
    //                   ? Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: [
    //                         MenuItem(
    //                           fade: false,
    //                           iconData: Icons.person,
    //                           menuName: 'Digital ID Card',
    //                           pressHandler: () {
    //                             Navigator.push(
    //                                 context,
    //                                 MaterialPageRoute(
    //                                     builder: (context) => Profile()));
    //                           },
    //                         ),
    //                         MenuItem(
    //                           fade: true,
    //                           iconData: Icons.apartment_rounded,
    //                           menuName: 'Hostel',
    //                           pressHandler: () {},
    //                         ),
    //                       ],
    //                     )
    //                   : Container(),
    //               widget.role != 'guard'
    //                   ? Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: [
    //                         MenuItem(
    //                           fade: false,
    //                           iconData: Icons.food_bank,
    //                           menuName: 'Mess',
    //                           pressHandler: () {
    //                             Navigator.push(
    //                                 context,
    //                                 MaterialPageRoute(
    //                                     builder: (context) =>
    //                                         const MessScreen()));
    //                           },
    //                         ),
    //                         MenuItem(
    //                           fade: true,
    //                           iconData: Icons.medical_services_rounded,
    //                           menuName: 'Medical',
    //                           pressHandler: () {},
    //                         ),
    //                       ],
    //                     )
    //                   : Container(),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   widget.role != 'guard'
    //                       ? MenuItem(
    //                           fade: false,
    //                           iconData: Icons.admin_panel_settings_rounded,
    //                           menuName: 'Gate Pass',
    //                           pressHandler: () {
    //                             Navigator.push(
    //                                 context,
    //                                 MaterialPageRoute(
    //                                   builder: (context) =>
    //                                       const PurposeScreen(),
    //                                 ));
    //                           },
    //                         )
    //                       : MenuItem(
    //                           fade: false,
    //                           iconData: Icons.admin_panel_settings_rounded,
    //                           menuName: 'Scan Gate Pass',
    //                           pressHandler: () {
    //                             Navigator.push(
    //                                 context,
    //                                 MaterialPageRoute(
    //                                   builder: (context) =>
    //                                       const ScanGatePass(),
    //                                 ));
    //                           },
    //                         ),
    //                 ],
    //               )
    //             ]),
    //           ),
    //         ),
    //       ),
    //       const SizedBox(
    //         height: 20.0,
    //       ),
    //       TextButton(
    //         child: Text(
    //           'Sign Out',
    //           style: TextStyle(
    //             color: widget.role != 'guard'
    //                 ? const Color(0xff3a82fd)
    //                 : Colors.white,
    //           ),
    //         ),
    //         onPressed: () async {
    //           if (widget.role == 'guard') {
    //             await widget.secureStorage.delete(key: 'guardToken');
    //           } else {
    //             await authService.signOut();
    //           }
    //           Navigator.pushReplacement(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => const LoginScreen(),
    //             ),
    //           );
    //         },
    //       )
    //     ],
    //   ),
    // );
  }
}
