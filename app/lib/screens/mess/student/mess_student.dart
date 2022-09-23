import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/mess/student/complains_mess_student.dart';
import 'package:ira/screens/mess/factories/mess.dart';
import 'package:ira/screens/mess/student/feedback_mess_student.dart';
import 'package:ira/screens/mess/student/menu_mess_student.dart';
import 'package:ira/screens/mess/student/mom_mess_student.dart';
import 'package:ira/screens/mess/student/tender_mess_student.dart';
import 'package:http/http.dart' as http;
import 'package:ira/shared/alert_snackbar.dart';

class MessStudentScreen extends StatefulWidget {
  const MessStudentScreen({Key? key}) : super(key: key);

  @override
  State<MessStudentScreen> createState() => _MessStudentScreenState();
}

class _MessStudentScreenState extends State<MessStudentScreen> {
  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  Future<Map<String, List<Mess>>> fetchMessData() async {
    String? idToken = await secureStorage.read(key: 'idToken');
    final response = await http.get(
        Uri.parse(
          baseUrl + '/mess/all_items',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'idToken ' + idToken!
        });

    Map<String, List<Mess>> mmp = {};

    if (response.statusCode == 200) {
      List decodedData = jsonDecode(response.body) as List;
      mmp = {
        'data': decodedData.map<Mess>((json) => Mess.fromJson(json)).toList(),
      };
    }
    // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);

    return Future.value(mmp);
  }

  final List<String> _messList = [
    "Feedback",
    "Complaint",
    "Menu",
    "Mess MOM",
    "Tenders"
  ];

  final List<Widget> _messRoutes = [
    FeedbackMess(),
    ComplaintsMess(),
    const MessMenu(),
    MOMMess(),
    TenderMess(),
  ];

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
            height: size.height * 0.1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text("Mess",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.0,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.7,
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
                    horizontal: 20.0, vertical: 40.0),
                child: GridView.builder(
                  itemCount: _messList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => _messRoutes[index]));
                      },
                      child: Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ),
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                  height: 40.0,
                                  width: 40.0,
                                  child: Image.asset(
                                      "assets/images/mess_icon.png")),
                              const SizedBox(height: 4.0),
                              Text(
                                _messList[index],
                                style: const TextStyle(fontSize: 12.0),
                              ),
                            ],
                          ),
                        ),
                      ),
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
