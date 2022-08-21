import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/medical/doctor_details.dart/doctor_card.dart';
import 'package:http/http.dart' as http;

class DoctorModel {
  String name;
  String contact;
  String specialization;
  String mail;
  String startTime;
  String endTime;
  String details;

  DoctorModel({
    required this.name,
    required this.contact,
    required this.specialization,
    required this.mail,
    required this.startTime,
    required this.endTime,
    required this.details,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      name: json['name'],
      contact: json['phone'],
      specialization: json['specialization'],
      mail: json['mail'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      details: json['details'],
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

  Future<Map<String, List<DoctorModel>>> fetchDoctorDetails() async {
    String? idToken = await secureStorage.read(key: 'idToken');
    final response = await http.get(
        Uri.parse(
          baseUrl + '/medical/student/doctor/',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'idToken ' + idToken!
        });

    Map<String, List<DoctorModel>> mmp = {};

    if (response.statusCode == 200) {
      List decodedBody = jsonDecode(response.body);

      mmp['data'] = decodedBody
          .map<DoctorModel>((json) => DoctorModel.fromJson(json))
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
                  vertical: 20.0,
                ),
                child: FutureBuilder(
                  future: fetchDoctorDetails(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.data == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                        itemCount: snapshot.data['data'].length,
                        itemBuilder: (BuildContext context, int index) {
                          return DoctorCard(
                            name: snapshot.data['data'][index].name,
                            specialization:
                                snapshot.data['data'][index].specialization,
                            contact: snapshot.data['data'][index].contact,
                            details: snapshot.data['data'][index].details,
                            email: snapshot.data['data'][index].mail,
                            startTime: snapshot.data['data'][index].startTime,
                            endTime: snapshot.data['data'][index].endTime,
                          );
                        });
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
