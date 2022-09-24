import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/medical/staff_contact/staff_card.dart';
import 'package:http/http.dart' as http;

class StaffModel {
  String name;
  String contact;
  String designation;

  StaffModel({
    required this.name,
    required this.contact,
    required this.designation,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      name: json['name'],
      contact: json['phone'],
      designation: json['designation'],
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

  Future<Map<String, List<StaffModel>>> fetchStaff() async {
    String? idToken = await secureStorage.read(key: 'idToken');
    final response = await http.get(
        Uri.parse(
          baseUrl + '/medical/student/staff/',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'idToken ' + idToken!
        });

    Map<String, List<StaffModel>> mmp = {};

    if (response.statusCode == 200) {
      List decodedData = jsonDecode(response.body);
      mmp['data'] = decodedData
          .map<StaffModel>((json) => StaffModel.fromJson(json))
          .toList();
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
                child: FutureBuilder(
                    future: fetchStaff(),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<dynamic> snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.data == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ListView.builder(
                          itemCount: snapshot.data['data'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return StaffCard(
                              name: snapshot.data['data'][index].name,
                              designation:
                                  snapshot.data['data'][index].designation,
                              contact: snapshot.data['data'][index].contact,
                            );
                          });
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
