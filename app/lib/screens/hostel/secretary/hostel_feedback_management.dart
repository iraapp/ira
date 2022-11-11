import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'models/hostel_feedback_model.dart';

class HostelFeedbackManagement extends StatefulWidget {
  HostelFeedbackManagement({Key? key}) : super(key: key);
  final secureStorage = const FlutterSecureStorage();
  final String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  @override
  State<HostelFeedbackManagement> createState() =>
      _HostelFeedbackManagementState();
}

class _HostelFeedbackManagementState extends State<HostelFeedbackManagement> {
  Future<List<HostelFeedbackModel>> _getHostelFeedbackItems() async {
    final String? idToken = await widget.secureStorage.read(key: 'idToken');
    final requestUrl = Uri.parse(widget.baseUrl + '/hostel/feedback');
    final response = await http.get(
      requestUrl,
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
        'Authorization': 'idToken ' + idToken!,
      },
    );

    List<HostelFeedbackModel> data = [];

    if (response.statusCode == 200) {
      data = jsonDecode(response.body)
          .map<HostelFeedbackModel>(
              (json) => HostelFeedbackModel.fromJson(json))
          .toList();
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text(
          "Feedbacks",
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
            color: Colors.white,
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: FutureBuilder(
                future: _getHostelFeedbackItems(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<HostelFeedbackModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          final data = snapshot.data![index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              children: [
                                Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0),
                                        topLeft: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                      ),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0.0, 1.0), //(x,y)
                                          blurRadius: 1.0,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10.0),
                                              bottomRight: Radius.circular(0.0),
                                              topLeft: Radius.circular(10.0),
                                              bottomLeft: Radius.circular(0.0),
                                            ),
                                            color: Colors.blue,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(data.user,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    )),
                                                Row(
                                                  children: [
                                                    Text(
                                                      data.hostel,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    const Text(
                                                      " | ",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      data.createdAt,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Text(data.body,
                                              style: const TextStyle(
                                                color: Colors.black,
                                              )),
                                        ),
                                      ],
                                    )),
                                const SizedBox(height: 20),
                              ],
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
        ),
      ),
    );
  }
}
