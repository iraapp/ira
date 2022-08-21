import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DoctorCard extends StatelessWidget {
  final String name;
  final String contact;
  final String designation;
  final String degree;
  final String email;

  const DoctorCard({
    Key? key,
    required this.name,
    required this.degree,
    required this.designation,
    required this.contact,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30.00, 25.00, 30.0, 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            degree,
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
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ]),
                    const Text("Details: ")
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding:
                          const EdgeInsets.fromLTRB(10.0, 12.5, 10.0, 12.5),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Take Appointment",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding:
                          const EdgeInsets.fromLTRB(10.0, 12.5, 10.0, 12.5),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20.0),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Timing - 2.00 - 4.00",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20.0,
        )
      ],
    );
  }
}

class DoctorDetailsScreen extends StatefulWidget {
  const DoctorDetailsScreen({Key? key}) : super(key: key);

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
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
                      child: Text("Doctor Details",
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
                    DoctorCard(
                      name: "Dr Rohit Bhatti",
                      designation: "Physiotherapist",
                      degree: "MBBS",
                      contact: "+91 8767976787",
                      email: "rohit.bhatti@iitjammu.ac.in",
                    ),
                    DoctorCard(
                      name: "Dr Pranav Gupta",
                      designation: "Dentist",
                      degree: "BAMS",
                      contact: "+91 9872672892",
                      email: "pranav.gupta@iitjammu.ac.in",
                    )
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
