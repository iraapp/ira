import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ira/screens/medical/manager/appointments/appointment_card.dart';

import '../../doctor_details/doctor_details.dart';

class AppointmentManagerModel {
  int id;
  DoctorModel doctor;
  String? date;
  String? startTime;
  String? endTime;
  String status;
  String patientName;
  String patientMail;

  AppointmentManagerModel(
      {required this.id,
      required this.doctor,
      required this.date,
      required this.startTime,
      required this.endTime,
      required this.status,
      required this.patientName,
      required this.patientMail});

  factory AppointmentManagerModel.fromJson(Map<String, dynamic> json) {
    return AppointmentManagerModel(
      id: json['id'],
      doctor: DoctorModel.fromJson(json['doctor']),
      date: json['date'],
      status: json['status'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      patientMail: json['patient']['email'],
      patientName:
          json['patient']['first_name'] + ' ' + json['patient']['last_name'],
    );
  }
}

class AppointmentsManagement extends StatefulWidget {
  const AppointmentsManagement({Key? key}) : super(key: key);

  @override
  State<AppointmentsManagement> createState() => _AppointmentsManagementState();
}

class _AppointmentsManagementState extends State<AppointmentsManagement> {
  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];
  bool _isActive = true;

  Future<Map<String, List<AppointmentManagerModel>>> fetchAppointments() async {
    String? token = await secureStorage.read(key: 'staffToken');
    final response = await http.get(
        Uri.parse(
          baseUrl + '/medical/manager/appointments',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token != null ? 'Token ' + token : ''
        });

    Map<String, List<AppointmentManagerModel>> mmp = {};

    if (response.statusCode == 200) {
      List decodedBody = jsonDecode(response.body);
      mmp['data'] = decodedBody
          .map<AppointmentManagerModel>(
            (json) => AppointmentManagerModel.fromJson(json),
          )
          .toList();
    }

    return Future.value(mmp);
  }

  Future<Map<String, List<AppointmentManagerModel>>>
      fetchPendingAppointments() async {
    String? token = await secureStorage.read(key: 'staffToken');
    final response = await http.get(
        Uri.parse(
          baseUrl + '/medical/manager/appointments/pending',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token != null ? 'Token ' + token : ''
        });

    Map<String, List<AppointmentManagerModel>> mmp = {};

    if (response.statusCode == 200) {
      List decodedBody = jsonDecode(response.body);
      mmp['data'] = decodedBody
          .map<AppointmentManagerModel>(
            (json) => AppointmentManagerModel.fromJson(json),
          )
          .toList();
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
                      child: Text(
                        "Appointments",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                        ),
                      ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isActive = true;
                            });
                          },
                          child: Text("Requests",
                              style: TextStyle(
                                decoration:
                                    _isActive ? TextDecoration.underline : null,
                                color: _isActive ? Colors.blue : Colors.black,
                                fontSize: 16,
                              )),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isActive = false;
                            });
                          },
                          child: Text("Pending",
                              style: TextStyle(
                                fontSize: 16,
                                color: !_isActive ? Colors.blue : Colors.black,
                                decoration: !_isActive
                                    ? TextDecoration.underline
                                    : null,
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: size.height * 0.7,
                    child: FutureBuilder(
                      future: _isActive
                          ? fetchAppointments()
                          : fetchPendingAppointments(),
                      builder: (BuildContext context,
                          AsyncSnapshot<
                                  Map<String, List<AppointmentManagerModel>>>
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
                              return AppointmentCard(
                                appointment: snapshot.data!['data']![index],
                                requestsView: _isActive,
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
