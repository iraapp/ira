import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/mess/complains_mess_student.dart';
import 'package:ira/screens/mess/components/mess_weekday.dart';
import 'package:ira/screens/mess/factories/mess.dart';
import 'package:ira/screens/mess/feedback_mess_student.dart';
import 'package:ira/screens/mess/menu_mess_student.dart';
import 'package:ira/screens/mess/mom_mess_student.dart';
import 'package:ira/screens/mess/tender_mess_student.dart';
import 'package:ira/shared/app_scaffold.dart';
import 'package:http/http.dart' as http;

class MessStudentScreen extends StatefulWidget {
  const MessStudentScreen({Key? key}) : super(key: key);

  @override
  State<MessStudentScreen> createState() => _MessStudentScreenState();
}

class _MessStudentScreenState extends State<MessStudentScreen> {
  String _messDropdownValue = '0';
  String _dayDropdownValue = '0';
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

    return Future.value(mmp);
  }

  List<String> _messList = [
    "Feedback",
    "Complaint",
    "Menu",
    "Mess Leave",
    "Food Request",
    "Mess MOM",
    "Tenders"
  ];

  List<Widget> _messRoutes = [
    FeedbackMess(),
    ComplaintsMess(),
    MessMenu(),
    Container(),
    // MessLeaveMess(),
    Container(),
    // FoodRequestMess(),
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text("Mess",
                          style: const TextStyle(
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40.0),
                  bottomRight: Radius.circular(0.0),
                  topLeft: Radius.circular(40.0),
                  bottomLeft: Radius.circular(0.0),
                ),
                color: const Color(0xfff5f5f5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 40.0),
                child: GridView.builder(
                  itemCount: _messList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                        decoration: BoxDecoration(
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
                                  height: 60.0,
                                  width: 60.0,
                                  child: Image.asset(
                                      "assets/images/mess_icon.png")),
                              SizedBox(height: 4.0),
                              Text(_messList[index]),
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
    // return FutureBuilder(
    //     future: fetchMessData(),
    //     builder: (BuildContext context,
    //         AsyncSnapshot<Map<String, List<Mess>>> snapshot) {
    // if (snapshot.connectionState == ConnectionState.waiting ||
    //     snapshot.data == null) {
    //   return const Scaffold(
    //     body: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }

    // return AppScaffold(
    //   child: Column(
    //     children: [
    //       Center(
    //         child: Column(
    //           children: [
    //             Container(
    //               width: MediaQuery.of(context).size.width * 0.9,
    //               decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.circular(10),
    //                 boxShadow: const [
    //                   BoxShadow(
    //                       color: Colors.grey,
    //                       blurRadius: 5.0,
    //                       offset: Offset(
    //                         0,
    //                         5,
    //                       ))
    //                 ],
    //               ),
    //               child: Padding(
    //                 padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
    //                 child: Column(children: <Widget>[
                      // DropdownButton<String>(
                      //   borderRadius: BorderRadius.circular(10.0),
                      //   isExpanded: true,
                      //   items: snapshot.data!["data"]
                      //       ?.asMap()
                      //       .entries
                      //       .map((entry) {
                      //     return DropdownMenuItem<String>(
                      //       child: Text(entry.value.name),
                      //       value: entry.key.toString(),
                      //     );
                      //   }).toList(),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       _messDropdownValue = value!;
                      //     });
                      //   },
                      //   value: _messDropdownValue,
                      // ),
                      // DropdownButton<String>(
                      //   borderRadius: BorderRadius.circular(10.0),
                      //   isExpanded: true,
                      //   items: snapshot
                      //       .data!["data"]![int.parse(_messDropdownValue)]
                      //       .weekDays
                      //       .asMap()
                      //       .entries
                      //       .map((entry) {
                      //     return DropdownMenuItem<String>(
                      //       child: Text(entry.value.name),
                      //       value: entry.key.toString(),
                      //     );
                      //   }).toList(),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       _dayDropdownValue = value!;
                      //     });
                      //   },
                      //   value: _dayDropdownValue,
                      // ),
                //     ]),
                //   ),
                // ),
                // Container(
                //     margin: const EdgeInsets.only(
                //       top: 30.0,
                //       bottom: 10.0,
                //     ),
                //     width: MediaQuery.of(context).size.width * 0.9,
                //     child: MessWeekDay(
                //         weekDay: snapshot
                //             .data!['data']![int.parse(_messDropdownValue)]
                //             .weekDays[int.parse(_dayDropdownValue)])),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//     //});
//   }
// }
