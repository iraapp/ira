import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ira/screens/mess/student/complains_mess_student.dart';

// ignore: must_be_immutable
class HostelComplaint extends StatefulWidget {
  bool feedback = false;

  HostelComplaint({Key? key, required this.feedback}) : super(key: key);
  final secureStorage = const FlutterSecureStorage();
  final String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  @override
  State<HostelComplaint> createState() => _HostelComplaintState();
}

Future<Map<String, List<String>>> getHostelListAndComplaintTypes(
    baseUrl, idToken) async {
  final response = await http.get(
      Uri.parse(baseUrl + '/hostel/hostel-complaint-list'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'idToken ' + await idToken!
      });

  Map<String, List<String>> mmp = {'hostel': [], 'complaints': []};

  if (response.statusCode == 200) {
    final decodedBody = jsonDecode(response.body);
    decodedBody['hostel']
        .forEach((hostel) => {mmp['hostel']?.add(hostel['name'])});
    decodedBody['complaints']
        .forEach((complaint) => {mmp['complaints']?.add(complaint['name'])});
  }

  return mmp;
}

class _HostelComplaintState extends State<HostelComplaint> {
  List<String> _hostel = [];
  String _hostelValue = "";
  List<String> _complaintTypes = [];
  String _complaintTypeValue = "";

  String _description = "";
  late Future<Map<String, List<String>>> future;

  @override
  void initState() {
    Future<String?> idToken = widget.secureStorage.read(key: 'idToken');
    future = getHostelListAndComplaintTypes(widget.baseUrl, idToken);
    super.initState();
  }

  Future<dynamic> _submitHostelFeedback(
      String hostel, String complaintType, String description) async {
    String? idToken = await widget.secureStorage.read(key: 'idToken');

    Map<String, dynamic> formMap = {
      'hostel': hostel,
      'complaint_type': complaintType,
      'feedback': description
    };

    final requestUrl = Uri.parse(widget.baseUrl + '/hostel/feedback');
    final response = await http.post(
      requestUrl,
      headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': 'idToken ' + idToken!
      },
      encoding: Encoding.getByName('utf-8'),
      body: formMap,
    );

    if (response.statusCode == 200) {
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text(
          "Hostel",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(
            height: size.height -
                (MediaQuery.of(context).padding.top + kToolbarHeight),
          ),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40.0),
                bottomRight: Radius.circular(0.0),
                topLeft: Radius.circular(40.0),
                bottomLeft: Radius.circular(0.0),
              ),
              color: Color(0xfff5f5f5),
            ),
            child: FutureBuilder(
              future: future,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                _hostel = snapshot.data['hostel'];
                _complaintTypes = snapshot.data['complaints'];
                _complaintTypes = _complaintTypes
                    .where((element) => element != 'Feedback')
                    .toList();

                if (_hostel.isNotEmpty && _complaintTypes.isNotEmpty) {
                  if (_hostelValue == "") _hostelValue = _hostel[0];
                  if (_complaintTypeValue == "") {
                    _complaintTypeValue = _complaintTypes[0];
                  }
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            widget.feedback ? "Feedback" : "Complaint",
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 0.0),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Hostel:",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      )),
                                  SizedBox(
                                    width: 100,
                                    child: DropdownButton<String>(
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.black,
                                      ),
                                      value: _hostelValue,
                                      items: _hostel.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(
                                            items,
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _hostelValue = value!;
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(10.0),
                                      isExpanded: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            widget.feedback
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Complaint Type:",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0,
                                            )),
                                        SizedBox(
                                          width: 100,
                                          child: DropdownButton<String>(
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.black,
                                            ),
                                            value: _complaintTypeValue,
                                            items: _complaintTypes
                                                .map((String items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(
                                                  items,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                _complaintTypeValue = value!;
                                              });
                                            },
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            isExpanded: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
                              child: Row(
                                children: const [
                                  Text("Description:",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      )),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
                              child: TextField(
                                maxLines: 5,
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Description",
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _description = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40.0, vertical: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 140.0,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          if (_description.isNotEmpty) {
                                            final res =
                                                await _submitHostelFeedback(
                                                    _hostelValue,
                                                    widget.feedback
                                                        ? "Feedback"
                                                        : _complaintTypeValue,
                                                    _description);
                                            if (res) {
                                              await showFeedbackDialog(context,
                                                  title: "Thank you",
                                                  content:
                                                      "We wil try to improve our service",
                                                  defaultActionText: "Close");
                                              Navigator.of(context).pop();
                                            }
                                          }
                                        },
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                            ),
                                          ),
                                        ),
                                        child: const Text("Submit",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ))),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
