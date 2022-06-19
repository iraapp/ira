import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/mess/components/mess_weekday.dart';
import 'package:ira/screens/mess/factories/mess.dart';
import 'package:ira/shared/app_scaffold.dart';
import 'package:http/http.dart' as http;

class MessScreen extends StatefulWidget {
  const MessScreen({Key? key}) : super(key: key);

  @override
  State<MessScreen> createState() => _MessScreenState();
}

class _MessScreenState extends State<MessScreen> {
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchMessData(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, List<Mess>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return AppScaffold(
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5.0,
                                offset: Offset(
                                  0,
                                  5,
                                ))
                          ],
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                          child: Column(children: <Widget>[
                            DropdownButton<String>(
                              borderRadius: BorderRadius.circular(10.0),
                              isExpanded: true,
                              items: snapshot.data!["data"]
                                  ?.asMap()
                                  .entries
                                  .map((entry) {
                                return DropdownMenuItem<String>(
                                  child: Text(entry.value.name),
                                  value: entry.key.toString(),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _messDropdownValue = value!;
                                });
                              },
                              value: _messDropdownValue,
                            ),
                            DropdownButton<String>(
                              borderRadius: BorderRadius.circular(10.0),
                              isExpanded: true,
                              items: snapshot
                                  .data!["data"]![int.parse(_messDropdownValue)]
                                  .weekDays
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                return DropdownMenuItem<String>(
                                  child: Text(entry.value.name),
                                  value: entry.key.toString(),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _dayDropdownValue = value!;
                                });
                              },
                              value: _dayDropdownValue,
                            ),
                          ]),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(
                            top: 30.0,
                            bottom: 10.0,
                          ),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: MessWeekDay(
                              weekDay: snapshot
                                  .data!['data']![int.parse(_messDropdownValue)]
                                  .weekDays[int.parse(_dayDropdownValue)])),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
