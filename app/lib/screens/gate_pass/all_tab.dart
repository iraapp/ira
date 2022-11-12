import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/gate_pass/student_card.dart';
import 'package:ira/screens/gate_pass/student_data_model.dart';
import 'package:http/http.dart' as http;

class AllTab extends StatefulWidget {
  const AllTab({Key? key}) : super(key: key);

  @override
  State<AllTab> createState() => _AllTabState();
}

class _AllTabState extends State<AllTab> {
  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  Future<List<StudentDataModel>> getList() async {
    String? token = await secureStorage.read(key: 'staffToken');
    final response = await http.get(
        Uri.parse(
          baseUrl + '/gate_pass/all',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token != null ? 'Token ' + token : '',
        });

    if (response.statusCode == 200) {
      dynamic decodedData = jsonDecode(response.body);

      return decodedData
          .map<StudentDataModel>((json) => StudentDataModel.fromJson(json))
          .toList();
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
    }

    return Future.value([]);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 15,
      color: Colors.white,
      backgroundColor: Colors.blue,
      onRefresh: () async {
        setState(() {});
      },
      child: FutureBuilder<List<StudentDataModel>>(
          future: getList(),
          builder: (BuildContext context,
              AsyncSnapshot<List<StudentDataModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return StudentCard(
                  name: snapshot.data![index].name,
                  entryNo: snapshot.data![index].entryNo,
                  purpose: snapshot.data![index].purpose,
                  contact: snapshot.data![index].contact,
                  currentlyOut: snapshot.data![index].currentlyOut,
                  outTime: snapshot.data![index].outTime,
                  inTime: snapshot.data![index].inTime,
                );
              },
            );
          }),
    );
  }
}
