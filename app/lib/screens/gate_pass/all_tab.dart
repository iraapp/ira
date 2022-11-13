import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
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
  TextEditingController dateinput = TextEditingController();
  DateTime pickedDate = DateTime.now();

  Future<List<StudentDataModel>> getList() async {
    String? token = await secureStorage.read(key: 'staffToken');
    final response = await http.get(
        Uri.parse(
          baseUrl + '/gate_pass/all?date=' + dateinput.text,
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
  void initState() {
    super.initState();
    dateinput.text = DateFormat('yyyy-MM-dd').format(pickedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(0),
          child: Center(
              child: TextField(
            controller: dateinput, //editing controller of this TextField
            decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today), //icon of text field
                labelText: "Enter Date" //label text of field
                ),
            readOnly:
                true, //set it true, so that user will not able to edit text
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(
                      2000), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101));

              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);

                setState(() {
                  dateinput.text =
                      formattedDate; //set output date to TextField value.
                });
              }
            },
          )),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 420,
          child: RefreshIndicator(
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
          ),
        ),
      ],
    );
  }
}
