import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/hostel/maintenance_staff/contact_card.dart';
import 'package:http/http.dart' as http;

class MaintenanceContactModel {
  String name;
  String contact;
  String designation;
  String endTime;
  String location;
  String startTime;

  MaintenanceContactModel({
    required this.name,
    required this.contact,
    required this.designation,
    required this.endTime,
    required this.location,
    required this.startTime,
  });

  factory MaintenanceContactModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceContactModel(
      name: json['name'],
      contact: json['contact'],
      designation: json['designation'],
      endTime: json['end_time'],
      location: json['location'],
      startTime: json['start_time'],
    );
  }
}

class MaintenanceStaffContact extends StatelessWidget {
  MaintenanceStaffContact({Key? key}) : super(key: key);

  final secureStorage = const FlutterSecureStorage();
  final String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  Future<Map<String, List<MaintenanceContactModel>>> fetchMaintenanceStaff(
      BuildContext context) async {
    String? idToken = await secureStorage.read(key: 'idToken');
    final response = await http.get(
        Uri.parse(
          baseUrl + '/hostel/maintenance/contact',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'idToken ' + idToken!
        });

    Map<String, List<MaintenanceContactModel>> mmp = {};

    if (response.statusCode == 200) {
      List decodedData = jsonDecode(response.body) as List;

      mmp = {
        'data': decodedData
            .map<MaintenanceContactModel>(
              (json) => MaintenanceContactModel.fromJson(json),
            )
            .toList(),
      };
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
    }

    return Future.value(mmp);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text(
          "Hostel",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(
            height: size.height -
                (MediaQuery.of(context).padding.top + kToolbarHeight),
          ),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40.0),
                bottomRight: Radius.circular(0.0),
                topLeft: Radius.circular(40.0),
                bottomLeft: Radius.circular(0.0),
              ),
              color: Color(0xfff5f5f5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30.0,
                ),
                const Text(
                  "Maintenance Staff Details",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                FutureBuilder<Map<String, List<MaintenanceContactModel>>>(
                    future: fetchMaintenanceStaff(context),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: ListView.builder(
                          itemCount: snapshot.data['data'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return MaintenanceContactCard(
                              designation:
                                  snapshot.data['data'][index].designation,
                              contact: snapshot.data['data'][index].contact,
                              endTime: snapshot.data['data'][index].endTime,
                              startTime: snapshot.data['data'][index].startTime,
                              location: snapshot.data['data'][index].location,
                              name: snapshot.data['data'][index].name,
                            );
                          },
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
