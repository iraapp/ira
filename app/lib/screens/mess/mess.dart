import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/mess/models.dart';
import 'package:ira/shared/app_scaffold.dart';
import 'package:http/http.dart' as http;
import '../../util/helpers.dart';

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
      // print('1');
      List decodedData = jsonDecode(response.body) as List;
      // print(decodedData);
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

class MessWeekDay extends StatelessWidget {
  final WeekDay weekDay;

  const MessWeekDay({
    Key? key,
    required this.weekDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
              color: Color.fromARGB(255, 20, 12, 12),
              blurRadius: 5.0,
              offset: Offset(
                0,
                5,
              ))
        ],
      ),
      child: Column(children: [
        Text(
          weekDay.name,
          style: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        SizedBox(
          height: 450,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: weekDay.slots.length,
            itemBuilder: (BuildContext context, int index) {
              return MessSlot(slot: weekDay.slots[index]);
            },
          ),
        ),
      ]),
    );
  }
}

class MessSlot extends StatelessWidget {
  final Slot slot;
  const MessSlot({
    Key? key,
    required this.slot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          slot.name,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Container(
          padding: const EdgeInsets.all(10.0),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: Column(
            // children: const [
            //   Text('Veg Sevaiyaan'),
            //   SizedBox(
            //     height: 5.0,
            //   ),
            // ],
            children: slot.items
                .map(
                  (e) => Column(
                    children: [
                      Text(e.name),
                      const SizedBox(
                        height: 5.0,
                      )
                    ],
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}
