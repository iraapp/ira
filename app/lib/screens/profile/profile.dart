import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flip_card/flip_card.dart';

import '../../util/helpers.dart';

class Profile extends StatefulWidget {
  final secureStorage = const FlutterSecureStorage();
  final String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<dynamic> fetchProfile() async {
    String? idToken = await widget.secureStorage.read(key: 'idToken');

    final response = await http.get(
      Uri.parse(widget.baseUrl + '/user_profile/student'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'idToken ' + idToken!
      },
    );

    if (response.statusCode == 200) {
      return Future.value(response.body);
    }

    return Future.value('invalid');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          height: getHeightOf(context) * 0.7,
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
          padding: EdgeInsets.only(top: getHeightOf(context) * 0.25),
          child: FutureBuilder(
              future: fetchProfile(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data != 'invalid') {
                  final profileData = jsonDecode(snapshot.data);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: FlipCard(
                          direction: FlipDirection.HORIZONTAL,
                          front: Container(
                            margin: EdgeInsets.only(
                                top: getHeightOf(context) * 0.05),
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
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset(
                                        'assets/images/id_logo1.png',
                                      ),
                                      Image.asset(
                                        'assets/images/id_logo2.png',
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Name: ' + profileData['name']),
                                          const Text('ID No: '),
                                          Text('Discipline: ' +
                                              profileData['branch']),
                                          Text('Programme: ' +
                                              profileData['programme']),
                                          Text('DOB: ' +
                                              profileData['date_of_birth']),
                                          Text('Valid Upto: ' +
                                              profileData['valid_upto']),
                                        ],
                                      ),
                                      Column(children: [
                                        Image.asset(
                                            'assets/images/id_logo3.png'),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        const Text('Dean Academics'),
                                      ]),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          back: Container(
                            margin: EdgeInsets.only(
                                top: getHeightOf(context) * 0.05),
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
                              padding: const EdgeInsets.all(30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('E-mail: ' +
                                      profileData['entry_no'] +
                                      '@iitjammu.ac.in'),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text('Contact No: ' +
                                      profileData['phone_number']),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text('Emergency No: ' +
                                      profileData['emergency_no']),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text('Blood Group: ' +
                                      profileData['blood_group']),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'Permanent Address: ' +
                                        profileData['address'],
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  const Text(
                                      'www.iitjammu.ac.in | +91-191-257-0633'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  );
                }

                return Container();
              }),
        ),
      ]),
    );
  }
}
