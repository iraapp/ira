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
    final String? token = await widget.secureStorage.read(key: 'staffToken');
    final requestUrl = Uri.parse(widget.baseUrl + '/mess/feedback');
    final response = await http.get(
      requestUrl,
      headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': token != null ? 'Token ' + token : '',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data
          .map<FeedbackModel>((json) => FeedbackModel.fromJson(json))
          .toList();
    } else {
      throw Exception('API call failed');
    }
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
            child: FutureBuilder<List<FeedbackModel>>(
                future: _getMessFeedbackItems(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          final data = snapshot.data![index];
                          final day = DateTime.tryParse(data.createdAt)?.day;
                          final month =
                              DateTime.tryParse(data.createdAt)?.month;
                          final year = DateTime.tryParse(data.createdAt)?.year;
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
                                                Text(
                                                    "${data.messType} | ${data.messMeal} | $date",
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
