import 'package:flutter/material.dart';
import 'package:institute_app/screens/dashboard/components/menu_item.dart';
import 'package:institute_app/screens/gate_pass/gate_pass.dart';
import 'package:institute_app/screens/gate_pass/purpose.dart';
import 'package:institute_app/services/auth.service.dart';
import 'package:provider/provider.dart';

String capitalize(String str) {
  return '${str[0].toUpperCase()}${str.substring(1).toLowerCase()}';
}

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of(context);

    return Scaffold(
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff3a82fd),
                  Color(0xff5077d3),
                  Color(0xff3c91c8),
                  Color(0xff72a8ee),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(60, 20),
                bottomRight: Radius.elliptical(60, 20),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 50.0),
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
                      Text(
                        capitalize((authService.user?.displayName ?? '')
                                .split(' ')[0]) +
                            ' ' +
                            capitalize((authService.user?.displayName ?? '')
                                .split(' ')[1]),
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MenuItem(
                            iconData: Icons.account_balance_rounded,
                            menuName: 'Academics',
                            pressHandler: () {},
                          ),
                          MenuItem(
                            iconData: Icons.apartment_rounded,
                            menuName: 'Hostel',
                            pressHandler: () {},
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MenuItem(
                            iconData: Icons.food_bank,
                            menuName: 'Mess',
                            pressHandler: () {},
                          ),
                          MenuItem(
                            iconData: Icons.medical_services_rounded,
                            menuName: 'Medical',
                            pressHandler: () {},
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MenuItem(
                            iconData: Icons.admin_panel_settings_rounded,
                            menuName: 'Gate Pass',
                            pressHandler: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PurposeScreen(),
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
                height: 30.0,
              ),
              TextButton(
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Color(0xff3a82fd),
                  ),
                ),
                onPressed: () async {
                  await authService.signOut();
                },
              )
            ],
          ),
        ),
      ]),
    );
  }
}
