import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Staff extends StatelessWidget {
  final String name;
  final String designation;
  final String contact;

  const Staff({
    Key? key,
    required this.name,
    required this.designation,
    required this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(30.00, 25.00, 30.0, 25.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(81, 158, 158, 158),
                offset: Offset(0, 3),
                blurRadius: 3.0,
              ),
            ],
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Image.asset("assets/icons/staff_contact_profile.png"),
              const SizedBox(
                width: 15.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    designation,
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    contact,
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ]),
            CircleAvatar(
              backgroundColor: Colors.green,
              child: Image.asset("assets/icons/call.png"),
            )
          ]),
        ),
        const SizedBox(
          height: 20.0,
        )
      ],
    );
  }
}

class StaffContactScreen extends StatefulWidget {
  const StaffContactScreen({Key? key}) : super(key: key);

  @override
  State<StaffContactScreen> createState() => _StaffContactScreenState();
}

class _StaffContactScreenState extends State<StaffContactScreen> {
  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: size.height * 0.05,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text("Staff Contact",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.8,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40.0),
                  bottomRight: Radius.circular(0.0),
                  topLeft: Radius.circular(40.0),
                  bottomLeft: Radius.circular(0.0),
                ),
                color: Color(0xfff5f5f5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 40.0,
                ),
                child: Column(
                  children: const [
                    Staff(
                      name: "Dr Karunika Sharma",
                      designation: "Doctor",
                      contact: "+91 9755467567",
                    ),
                    Staff(
                      name: "Dr Rohit Bhatti",
                      designation: "Doctor (Physiotherapist)",
                      contact: "+91 8767976787",
                    ),
                    Staff(
                      name: "Dr Pranav Gupta",
                      designation: "Doctor (Dental)",
                      contact: "+91 9872672892",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
