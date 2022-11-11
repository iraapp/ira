import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/medical/appointments/appointment_card.dart';
import 'package:ira/screens/medical/doctor_details/doctor_details.dart';
import 'package:http/http.dart' as http;

class AppointmentModel {
  int id;
  DoctorModel doctor;
  dynamic date;
  dynamic time;
  String status;
  dynamic reason;

  AppointmentModel({
    required this.id,
    required this.doctor,
    required this.date,
    required this.time,
    required this.status,
    required this.reason,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      doctor: DoctorModel.fromJson(json['doctor']),
      date: json['date'],
      reason: json['reason'],
      status: json['status'],
      time: json['time'],
    );
  }
}

class MedicalAppointmentsScreen extends StatefulWidget {
  const MedicalAppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<MedicalAppointmentsScreen> createState() =>
      _MedicalAppointmentsScreenState();
}

class _MedicalAppointmentsScreenState extends State<MedicalAppointmentsScreen> {
  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  Future<List<AppointmentModel>> fetchAppointments() async {
    String? idToken = await secureStorage.read(key: 'idToken');
    final response = await http.get(
        Uri.parse(
          baseUrl + '/medical/appointment/',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'idToken ' + idToken!
        });
    if (response.statusCode == 200) {
      List decodedBody = jsonDecode(response.body);
      List<AppointmentModel> appointments = decodedBody
          .map<AppointmentModel>((json) => AppointmentModel.fromJson(json))
          .toList();
      return Future.value(appointments);
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
    }

    return Future.value([]);
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
                      child: Text("Appointments",
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
                color: Color(0xfff5f5f5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 20.0,
                ),
                child: FutureBuilder(
                  future: fetchAppointments(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<AppointmentModel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.data == null) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AppointmentCard(
                          name: snapshot.data![index].doctor.name,
                          // details: snapshot.data[index].,
                          specialization:
                              snapshot.data![index].doctor.specialization,
                          contact: snapshot.data![index].doctor.contact,
                          email: snapshot.data![index].doctor.mail,
                          startTime: snapshot.data![index].doctor.startTime,
                          endTime: snapshot.data![index].doctor.endTime,
                          status: snapshot.data![index].status,
                          dateTime: snapshot.data![index].time != null
                              ? snapshot.data![index].time +
                                  " " +
                                  snapshot.data![index].date
                              : "",
                          reason: snapshot.data![index].reason,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
