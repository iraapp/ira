import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/mess/manager/feedback_model.dart';
import 'package:http/http.dart' as http;

class FeedbackMessManager extends StatefulWidget {
  FeedbackMessManager({Key? key}) : super(key: key);
  final secureStorage = const FlutterSecureStorage();
  final String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  @override
  State<FeedbackMessManager> createState() => _FeedbackMessManagerState();
}

class _FeedbackMessManagerState extends State<FeedbackMessManager> {
  Future<List<FeedbackModel>> _getMessFeedbackItems() async {
    String? idToken = await widget.secureStorage.read(key: 'idToken');

    final requestUrl = Uri.parse(widget.baseUrl + '/mess/feedback');
    final response = await http.get(
      requestUrl,
      headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': 'idToken ' + idToken!
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // print(data);
      return data
          .map<FeedbackModel>((json) => FeedbackModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text(
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40.0),
              bottomRight: Radius.circular(0.0),
              topLeft: Radius.circular(40.0),
              bottomLeft: Radius.circular(0.0),
            ),
            color: const Color(0xfff5f5f5),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: FutureBuilder<List<FeedbackModel>>(
                future: _getMessFeedbackItems(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          final data = snapshot.data![index];
                          final day = DateTime.tryParse(data.created_at)?.day;
                          final month =
                              DateTime.tryParse(data.created_at)?.month;
                          final year = DateTime.tryParse(data.created_at)?.year;
                          final date = day.toString() +
                              "-" +
                              month.toString() +
                              "-" +
                              year.toString();
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              children: [
                                Container(
                                    height: size.height * 0.25,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
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
                                          decoration: BoxDecoration(
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
                                                Text(
                                                    "1B Mess | Breakfast | $date",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Wrap(
                                            children: [
                                              Text(data.body,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                                SizedBox(height: 20),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ),
      ),
    );
  }
}

Future showAlertDialog(
  BuildContext context, {
  required String title,
  required String content,
  required String defaultActionText,
  String? cancelActionText,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        if (cancelActionText != null)
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(cancelActionText),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(defaultActionText),
        ),
      ],
    ),
  );
}
