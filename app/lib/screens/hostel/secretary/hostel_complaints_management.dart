import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/hostel/secretary/models/hostel_complaint_model.dart';
import 'package:http/http.dart' as http;
import 'package:ira/shared/alert_snackbar.dart';

class ComplaintHostelSecretary extends StatefulWidget {
  ComplaintHostelSecretary({Key? key}) : super(key: key);
  final secureStorage = const FlutterSecureStorage();
  final String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  @override
  State<ComplaintHostelSecretary> createState() =>
      _ComplaintHostelSecretaryState();
}

class _ComplaintHostelSecretaryState extends State<ComplaintHostelSecretary> {
  final List<String> _filters = ["Filter", "Hostel"];
  String _filterValue = "Filter";

  Future<List<HostelComplaintModel>> _getMessFeedbackItems() async {
    final String? idToken = await widget.secureStorage.read(key: 'idToken');
    final requestUrl = Uri.parse(widget.baseUrl + '/hostel/complaint');
    final response = await http.get(
      requestUrl,
      headers: <String, String>{
        "Content-Type": "application/json",
        'Authorization': 'idToken ' + idToken!,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data
          .map<HostelComplaintModel>(
              (json) => HostelComplaintModel.fromJson(json))
          .toList();
    }

    // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
    throw Exception('API Call failed');
  }

  Future<void> _takeActionOnComplaint(int id) async {
    final String? idToken = await widget.secureStorage.read(key: 'idToken');

    final requestUrl =
        Uri.parse(widget.baseUrl + '/hostel/complaint/action/$id/');
    final response = await http.put(
      requestUrl,
      headers: <String, String>{
        "Content-Type": "application/json",
        'Authorization': 'idToken ' + idToken!,
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text(
          "Complaints",
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
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40.0),
              bottomRight: Radius.circular(0.0),
              topLeft: Radius.circular(40.0),
              bottomLeft: Radius.circular(0.0),
            ),
            color: Color(0xfff5f5f5),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: 100,
                    child: DropdownButton<String>(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      value: _filterValue,
                      items: _filters.map((String items) {
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
                          _filterValue = value!;
                        });
                      },
                      borderRadius: BorderRadius.circular(10.0),
                      isExpanded: true,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Expanded(
                  child: FutureBuilder(
                      future: _getMessFeedbackItems(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<HostelComplaintModel>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (BuildContext context, int index) {
                                final data = snapshot.data![index];

                                final bool status = data.status;

                                return GestureDetector(
                                  onTap: () async {
                                    await showComplaintDialog(
                                      id: data.id,
                                      title: data.user,
                                      content: data.body,
                                      defaultActionText: "Close",
                                      status: status,
                                      subtitle: data.hostel +
                                          " | " +
                                          data.complaintType +
                                          " | " +
                                          data.createdAt,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Column(
                                      children: [
                                        Container(
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(10.0),
                                                  bottomRight:
                                                      Radius.circular(10.0),
                                                  topLeft:
                                                      Radius.circular(10.0),
                                                  bottomLeft:
                                                      Radius.circular(10.0),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                    offset: Offset(0.0, 1.0),
                                                    blurRadius: 1.0,
                                                  ),
                                                ],
                                                color: Colors.white),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(10.0),
                                                      bottomRight:
                                                          Radius.circular(0.0),
                                                      topLeft:
                                                          Radius.circular(10.0),
                                                      bottomLeft:
                                                          Radius.circular(0.0),
                                                    ),
                                                    color: !status
                                                        ? Colors.red
                                                        : Colors.green,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(data.user,
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                            !status
                                                                ? SizedBox(
                                                                    height:
                                                                        30.0,
                                                                    child:
                                                                        ElevatedButton(
                                                                      onPressed:
                                                                          null,
                                                                      style:
                                                                          ButtonStyle(
                                                                        backgroundColor:
                                                                            MaterialStateProperty.all(
                                                                          Colors
                                                                              .white,
                                                                        ),
                                                                        shape: MaterialStateProperty.all<
                                                                            RoundedRectangleBorder>(
                                                                          RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15.0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      child: const Text(
                                                                          "Take Action",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                12.0,
                                                                          )),
                                                                    ),
                                                                  )
                                                                : SizedBox(
                                                                    height:
                                                                        30.0,
                                                                    child:
                                                                        ElevatedButton(
                                                                      onPressed:
                                                                          () {},
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .done,
                                                                        color: Colors
                                                                            .green,
                                                                        size:
                                                                            18.0,
                                                                      ),
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        primary:
                                                                            Colors.white,
                                                                        shape:
                                                                            const CircleBorder(),
                                                                      ),
                                                                    ),
                                                                  ),
                                                          ],
                                                        ),
                                                        Builder(
                                                            builder: (context) {
                                                          return Text(
                                                            data.hostel +
                                                                " | " +
                                                                data.complaintType +
                                                                " | " +
                                                                data.createdAt,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          );
                                                        }),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: Wrap(
                                                    children: [
                                                      Text(data.body,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }

                        return const Center(
                          child: CircularProgressIndicator(),
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

  Future showComplaintDialog({
    required int id,
    required String title,
    required String subtitle,
    required String content,
    required String defaultActionText,
    required bool status,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16.0)),
                    const SizedBox(height: 10.0),
                    Text(subtitle, style: const TextStyle(fontSize: 14.0)),
                    const SizedBox(height: 10.0),
                  ],
                ),
                SizedBox(
                    height: 40.0,
                    child: Image.asset("assets/images/phone_icon.png")),
              ],
            ),
            const SizedBox(height: 10.0),
            Container(
                color: const Color(0xfff5f5f5),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(content, style: const TextStyle(fontSize: 14.0)),
                )),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Text("Details", style: TextStyle(fontSize: 14.0)),
              ],
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              height: 40.0,
              child: ElevatedButton(
                onPressed: () async {
                  if (!status) {
                    await _takeActionOnComplaint(id);
                    setState(() {
                      // update the status of the complaint
                      Navigator.pop(context);
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    !status ? Colors.red : Colors.green,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: Text(!status ? "Take Action" : "Action Taken",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    )),
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(defaultActionText),
          ),
        ],
      ),
    );
  }
}
