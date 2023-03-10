import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ira/screens/mess/student/models/mess_menu_model.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

import 'menu_page.dart';

class MessMenu extends StatefulWidget {
  final bool editable;
  const MessMenu({Key? key, required this.editable}) : super(key: key);

  @override
  State<MessMenu> createState() => _MessMenuState();
}

class _MessMenuState extends State<MessMenu> {
  final secureStorage = const FlutterSecureStorage();
  final String baseUrl = FlavorConfig.instance.variables['baseUrl'];
  final PageController controller =
      (PageController(initialPage: DateTime.now().weekday - 1));
  final _currentPageNotifier = ValueNotifier<int>(DateTime.now().weekday - 1);

  Future<List<WeekDayModel>> _getMessData() async {
    String? idToken = await secureStorage.read(key: 'idToken');
    String? staffToken = await secureStorage.read(key: 'staffToken');

    final requestUrl = Uri.parse(baseUrl + '/mess/all_items');
    final response = await http.get(
      requestUrl,
      headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization':
            widget.editable ? 'Token ' + staffToken! : 'idToken ' + idToken!
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> messData = jsonDecode(response.body);

      List<WeekDayModel> weekdays = [];
      for (var k in messData.keys) {
        weekdays.add(WeekDayModel.fromJson(
          {
            'weekday': k,
            'menus': messData[k],
          },
        ));
      }

      return Future.value(weekdays);
    }

    return Future.value([]);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Mess Menu'),
        backgroundColor: Colors.blue,
        elevation: 0.0,
        actions: widget.editable
            ? [
                TextButton(
                  onPressed: () {},
                  child: const Text('Add Day'),
                ),
              ]
            : [],
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder(
          future: _getMessData(),
          builder: (BuildContext context,
              AsyncSnapshot<List<WeekDayModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.data == null) {
              return Container();
            }

            return Stack(children: [
              PageView.builder(
                itemCount: snapshot.data?.length,
                controller: controller,
                itemBuilder: (BuildContext context, int index) {
                  return MenuPage(
                    weekDay: snapshot.data![index],
                    currentDay: DateTime.now().weekday == index + 1,
                    editable: widget.editable,
                    updateView: () {
                      setState(() {});
                    },
                  );
                },
                onPageChanged: (int index) {
                  _currentPageNotifier.value = index;
                },
              ),
              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CirclePageIndicator(
                    dotColor: Colors.grey.shade400,
                    selectedDotColor: Colors.blue.shade400,
                    itemCount: 7,
                    currentPageNotifier: _currentPageNotifier,
                  ),
                ),
              )
            ]);
          },
        ),
      ),
    );
  }
}
