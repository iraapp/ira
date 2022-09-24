import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ira/screens/mess/student/mess_menu_model.dart';

class WeekDayCarouselStudent extends StatelessWidget {
  WeekDayCarouselStudent({required this.weekDay, Key? key}) : super(key: key);
  final String weekDay;
  final secureStorage = const FlutterSecureStorage();
  final String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  Future<WeekDay> _getWeekDayData(BuildContext context) async {
    try {
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
        final data = jsonDecode(response.body);
        final weekData = data[weekDay];
        final MealType breakfast = MealType.fromJson(weekData["Breakfast"]);
        final MealType lunch = MealType.fromJson(weekData["Lunch"]);
        final MealType snacks = MealType.fromJson(weekData["Snacks"]);
        final MealType dinner = MealType.fromJson(weekData["Dinner"]);

        List<MealType> _meals = [breakfast, lunch, snacks, dinner];

        Map<String, dynamic> weekDataMap = {
          "weekday": weekDay,
          "meals": _meals,
        };
        return WeekDay.fromJson(weekDataMap);
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
        throw Exception('API Call Failed');
      }
    } catch (e) {
      return WeekDay(meals: [], weekday: "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getWeekDayData(context),
      builder: (BuildContext context, AsyncSnapshot<WeekDay> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            if (snapshot.data!.meals.isEmpty) {
              return const Center(
                child: Text("No data available"),
              );
            }
            final WeekDay data = snapshot.data!;
            return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          data.weekday,
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Breakfast',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            data.meals[0].slot.startTime +
                                ' - ' +
                                data.meals[0].slot.endTime,
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                      Wrap(
                        children: [
                          for (var item in data.meals[0].items)
                            Chip(label: Text(item.name))
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Lunch',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            data.meals[1].slot.startTime +
                                ' - ' +
                                data.meals[1].slot.endTime,
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                      Wrap(
                        children: [
                          for (var item in data.meals[1].items)
                            Chip(label: Text(item.name))
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Snacks',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            data.meals[2].slot.startTime +
                                ' - ' +
                                data.meals[2].slot.endTime,
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                      Wrap(
                        children: [
                          for (var item in data.meals[2].items)
                            Chip(label: Text(item.name))
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Dinner',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            data.meals[3].slot.startTime +
                                ' - ' +
                                data.meals[3].slot.endTime,
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                      Wrap(
                        children: [
                          for (var item in data.meals[3].items)
                            Chip(label: Text(item.name))
                        ],
                      ),
                    ],
                  ),
                ));
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
