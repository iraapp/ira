import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ira/screens/mess/student/mess_menu_model.dart';
import 'package:ira/screens/mess/student/weekday_carousel_student.dart';

class MessMenu extends StatefulWidget {
  const MessMenu({Key? key}) : super(key: key);

  @override
  State<MessMenu> createState() => _MessMenuState();
}

class _MessMenuState extends State<MessMenu> {
  final secureStorage = const FlutterSecureStorage();
  final String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  List<Widget> _weekdaysCarousels = [];

  Future<int> _getMessData() async {
    // try {
    String? idToken = await secureStorage.read(key: 'idToken');
    final requestUrl = Uri.parse(baseUrl + '/mess/all_items');
    final response = await http.get(
      requestUrl,
      headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': 'idToken ' + idToken!
      },
    );
    if (response.statusCode == 200) {
      // print(jsonDecode(response.body));
      Map<String, dynamic> messData = jsonDecode(response.body);

      _weekdaysCarousels = [];
      for (var k in messData.keys) {
        _weekdaysCarousels.add(
          WeekDayCarouselStudent(
            weekDay: WeekDay.fromJson({
              'weekday': k,
              'menus': messData[k],
            }),
          ),
        );
      }
    }

    return Future.value(1);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text(
          "Menu",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          height: size.height -
              (MediaQuery.of(context).padding.top + kToolbarHeight),
        ),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xfff5f5f5),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder(
                      future: _getMessData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.data == null) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (_weekdaysCarousels.isEmpty) {
                          return const Center(
                            child: Text("No data available"),
                          );
                        }
                        return CarouselSlider(
                          options: CarouselOptions(
                              height: MediaQuery.of(context).size.height * 0.7),
                          items: _weekdaysCarousels,
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
