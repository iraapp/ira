import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/medical/manager/doctor_details/add_new_doctor.dart';
import 'package:ira/screens/medical/manager/doctor_details/doctor_editable_card.dart';
import 'package:http/http.dart' as http;
import 'package:ira/shared/alert_snackbar.dart';

class DoctorManagerModel {
  int id;
  String name;
  String contact;
  String specialization;
  String mail;
  String date;
  String startTime;
  String endTime;
  String details;

  DoctorManagerModel({
    required this.id,
    required this.name,
    required this.contact,
    required this.specialization,
    required this.mail,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.details,
  });

  factory DoctorManagerModel.fromJson(Map<String, dynamic> json) {
    return DoctorManagerModel(
      id: json['id'],
      name: json['name'],
      contact: json['phone'],
      specialization: json['specialization'],
      mail: json['mail'],
      date: json['date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      details: json['details'],
    );
  }
}

class DoctorDetailsManager extends StatefulWidget {
  const DoctorDetailsManager({Key? key}) : super(key: key);

  @override
  State<DoctorDetailsManager> createState() => _DoctorDetailsManagerState();
}

class _DoctorDetailsManagerState extends State<DoctorDetailsManager> {
  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  Future<Map<String, List<DoctorManagerModel>>> fetchDoctorDetails() async {
    String? token = await secureStorage.read(key: 'staffToken');
    final response = await http.get(
        Uri.parse(
          baseUrl + '/medical/manager/doctor/',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token != null ? 'Token ' + token : ''
        });

    Map<String, List<DoctorManagerModel>> mmp = {};

    if (response.statusCode == 200) {
      List decodedBody = jsonDecode(response.body);

      mmp['data'] = decodedBody
          .map<DoctorManagerModel>(
            (json) => DoctorManagerModel.fromJson(json),
          )
          .toList();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
    }

    return Future.value(mmp);
  }

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
          Container(
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
                vertical: 10.0,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddNewDoctor(
                                updateView: () {
                                  setState(() {});
                                },
                                contact: '',
                                date: '',
                                details: '',
                                email: '',
                                endTime: '',
                                name: '',
                                specialization: '',
                                startTime: '',
                              ),
                            ),
                          );
                        },
                        child: const Text("+ Add New"),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color?>(Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: size.height * 0.7,
                    child: FutureBuilder(
                      future: fetchDoctorDetails(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String, List<DoctorManagerModel>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.data == null) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        return ListView.builder(
                            itemCount: snapshot.data!['data']?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return DoctorEditableCard(
                                contact: snapshot.data!['data']![index].contact,
                                date: snapshot.data!['data']![index].date,
                                details: snapshot.data!['data']![index].details,
                                email: snapshot.data!['data']![index].mail,
                                endTime: snapshot.data!['data']![index].endTime,
                                id: snapshot.data!['data']![index].id,
                                name: snapshot.data!['data']![index].name,
                                specialization: snapshot
                                    .data!['data']![index].specialization,
                                startTime:
                                    snapshot.data!['data']![index].startTime,
                                updateView: () {
                                  setState(() {});
                                },
                              );
                            });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
