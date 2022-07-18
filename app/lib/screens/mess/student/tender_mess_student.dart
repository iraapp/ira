import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ira/screens/mess/factories/mess.dart';
import 'package:ira/screens/mess/student/mess_tender_model.dart';

class TenderMess extends StatefulWidget {
  TenderMess({Key? key}) : super(key: key);
  final secureStorage = const FlutterSecureStorage();
  final String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  @override
  State<TenderMess> createState() => _TenderMessState();
}

class _TenderMessState extends State<TenderMess> {
  bool _isActive = true;

  Future<List<MessTenderModel>> _getMessTenderItems() async {
    String? idToken = await widget.secureStorage.read(key: 'idToken');

    final requestUrl = Uri.parse(widget.baseUrl + '/mess/tender');
    final response = await http.get(
      requestUrl,
      headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': 'idToken ' + idToken!
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data
          .map<MessTenderModel>((json) => MessTenderModel.fromJson(json))
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
          "Mess Tender",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        centerTitle: true,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          //TODO: Handle Active
                          setState(() {
                            _isActive = true;
                          });
                        },
                        child: Text("Active",
                            style: TextStyle(
                              decoration:
                                  _isActive ? TextDecoration.underline : null,
                              color: _isActive ? Colors.blue : Colors.black,
                              fontSize: 16,
                            )),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isActive = false;
                          });
                        },
                        child: Text("Archived",
                            style: TextStyle(
                              fontSize: 16,
                              color: !_isActive ? Colors.blue : Colors.black,
                              decoration:
                                  !_isActive ? TextDecoration.underline : null,
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text("Download old tenders here",
                    style: TextStyle(
                      fontSize: 14.0,
                    )),
                SizedBox(height: 20),
                Expanded(
                  child: FutureBuilder<List<MessTenderModel>>(
                      future: _getMessTenderItems(),
                      builder: (_, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (BuildContext context, int index) {
                                final data = snapshot.data![index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Column(
                                    children: [
                                      Container(
                                          // height: size.height * 0.1,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey,
                                                offset:
                                                    Offset(0.0, 1.0), //(x,y)
                                                blurRadius: 1.0,
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 20.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(data.title,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    )),
                                              ],
                                            ),
                                          )),
                                      SizedBox(height: 20),
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
              ],
            ),
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
