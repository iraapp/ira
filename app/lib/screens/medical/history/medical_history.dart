import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ira/screens/medical/history/history_card.dart';
import 'package:ira/shared/alert_snackbar.dart';

class MedicalHistoryModel {
  String date;
  String details;
  String diagnosis;
  String doctor;
  bool inhouse;
  String treatment;

  MedicalHistoryModel({
    required this.date,
    required this.details,
    required this.diagnosis,
    required this.doctor,
    required this.inhouse,
    required this.treatment,
  });

  factory MedicalHistoryModel.fromJson(Map<String, dynamic> json) {
    return MedicalHistoryModel(
      date: json['date'],
      details: json['details'],
      diagnosis: json['diagnosis'],
      doctor: json['doctor']['name'],
      inhouse: json['inhouse'],
      treatment: json['treatment'],
    );
  }
}

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({Key? key}) : super(key: key);

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  Future<List<MedicalHistoryModel>> fetchMedicalHistory() async {
    String? idToken = await secureStorage.read(key: 'idToken');
    final response = await http.get(
        Uri.parse(
          baseUrl + '/medical/medicalhistory/',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'idToken ' + idToken!
        });
    if (response.statusCode == 200) {
      List decodedBody = jsonDecode(response.body);
      List<MedicalHistoryModel> history = decodedBody
          .map<MedicalHistoryModel>(
              (json) => MedicalHistoryModel.fromJson(json))
          .toList();
      return Future.value(history);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
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
                      child: Text("History",
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
                  future: fetchMedicalHistory(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<MedicalHistoryModel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.data == null) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return HistoryCard(
                          date: snapshot.data![index].date,
                          details: snapshot.data![index].details,
                          diagnosis: snapshot.data![index].diagnosis,
                          doctor: snapshot.data![index].doctor,
                          inhouse: snapshot.data![index].inhouse,
                          treatment: snapshot.data![index].treatment,
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
