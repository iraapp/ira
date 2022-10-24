import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/medical/manager/staff_contact/staff_card.dart';
import 'package:http/http.dart' as http;

class StaffModel {
  int id;
  String name;
  String contact;
  String designation;

  StaffModel({
    required this.id,
    required this.name,
    required this.contact,
    required this.designation,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id'],
      name: json['name'],
      contact: json['phone'],
      designation: json['designation'],
    );
  }
}

class StaffContactManagerScreen extends StatefulWidget {
  const StaffContactManagerScreen({Key? key}) : super(key: key);

  @override
  State<StaffContactManagerScreen> createState() =>
      _StaffContactManagerScreenState();
}

class _StaffContactManagerScreenState extends State<StaffContactManagerScreen> {
  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  Future<Map<String, List<StaffModel>>> fetchStaff() async {
    String? token = await secureStorage.read(key: 'staffToken');

    final response = await http.get(
        Uri.parse(
          baseUrl + '/medical/manager/staff',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token != null ? 'Token ' + token : ''
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
                        onPressed: () async {
                          await addStaffDialog(context, baseUrl,
                              await secureStorage.read(key: 'staffToken'));
                        },
                        child: const Text("+ Add"),
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
                        future: fetchStaff(),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<dynamic> snapshot,
                        ) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              snapshot.data == null) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return ListView.builder(
                              itemCount: snapshot.data['data'].length,
                              itemBuilder: (BuildContext context, int index) {
                                return StaffCard(
                                  id: snapshot.data['data'][index].id,
                                  name: snapshot.data['data'][index].name,
                                  designation:
                                      snapshot.data['data'][index].designation,
                                  contact: snapshot.data['data'][index].contact,
                                  successCallback: () {
                                    setState(() {});
                                  },
                                );
                              });
                        }),
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

Future addStaffDialog(
  BuildContext context,
  String baseUrl,
  String? token,
) {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameFieldController = TextEditingController();
  TextEditingController professionFieldController = TextEditingController();
  TextEditingController contactFieldController = TextEditingController();

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10.0),
            Row(
              children: [
                const Text('Name : '),
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    controller: nameFieldController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name field cannot be empty';
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Profession : '),
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    controller: professionFieldController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Profession field cannot be empty';
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Contact : '),
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    controller: contactFieldController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Contact field cannot be empty';
                      }

                      return null;
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final response = await http.post(
                  Uri.parse(
                    baseUrl + '/medical/manager/staff',
                  ),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization': token != null ? 'Token ' + token : '',
                  },
                  body: jsonEncode(<String, String>{
                    'name': nameFieldController.text,
                    'profession': professionFieldController.text,
                    'contact': contactFieldController.text,
                  }));

              if (response.statusCode == 200) {
                Navigator.of(context).pop(false);
              } else {
                // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
              }
            }
          },
          child: const Text("Add"),
        ),
      ],
    ),
  );
}
