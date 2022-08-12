import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/mess/manager/feedback_model.dart';
import 'package:http/http.dart' as http;

class ComplaintMessManager extends StatefulWidget {
  ComplaintMessManager({Key? key}) : super(key: key);
  final secureStorage = const FlutterSecureStorage();
  final String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  @override
  State<ComplaintMessManager> createState() => _ComplaintMessManagerState();
}

class _ComplaintMessManagerState extends State<ComplaintMessManager> {
  bool _actionTaken = false;
  @override
  final List<String> _filter = ["Filter", "Date", "Mess", "Action"];
  String _filterValue = "Filter";
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

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text(
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
                  child: SizedBox(
                    width: 100,
                    child: DropdownButton<String>(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      value: _filterValue,
                      items: _filter.map((String items) {
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
                SizedBox(height: 10.0),
                Expanded(
                  child: FutureBuilder<List<FeedbackModel>>(
                      future: _getMessFeedbackItems(),
                      builder: (_, snapshot) {
                        print(snapshot.error);
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (BuildContext context, int index) {
                                final data = snapshot.data![index];
                                final day =
                                    DateTime.tryParse(data.created_at)?.day;
                                final month =
                                    DateTime.tryParse(data.created_at)?.month;
                                final year =
                                    DateTime.tryParse(data.created_at)?.year;
                                final date = day.toString() +
                                    "-" +
                                    month.toString() +
                                    "-" +
                                    year.toString();
                                return GestureDetector(
                                  onTap: () async {
                                    await showComplaintDialog(context,
                                        title: data.user,
                                        subtitle: "1B Mess | Breakfast | $date",
                                        content: data.body,
                                        defaultActionText: "Close");
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Column(
                                      children: [
                                        Container(
                                            height: size.height * 0.25,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
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
                                                    offset: Offset(
                                                        0.0, 1.0), //(x,y)
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
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(10.0),
                                                      bottomRight:
                                                          Radius.circular(0.0),
                                                      topLeft:
                                                          Radius.circular(10.0),
                                                      bottomLeft:
                                                          Radius.circular(0.0),
                                                    ),
                                                    color: !_actionTaken
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
                                                            !_actionTaken
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
                                                                      child: Text(
                                                                          "Take Action",
                                                                          style:
                                                                              const TextStyle(
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
                                                                          Icon(
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
                                                                            CircleBorder(),
                                                                      ),
                                                                    ),
                                                                  ),
                                                          ],
                                                        ),
                                                        Builder(
                                                            builder: (context) {
                                                          return Text(
                                                              "1B Mess | Breakfast | $date",
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ));
                                                        }),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
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
                                        SizedBox(height: 20),
                                      ],
                                    ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future showComplaintDialog(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String content,
    required String defaultActionText,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 16.0)),
                    SizedBox(height: 10.0),
                    Text(subtitle, style: TextStyle(fontSize: 14.0)),
                    SizedBox(height: 10.0),
                  ],
                ),
                SizedBox(
                    height: 40.0,
                    child: Image.asset("assets/images/phone_icon.png")),
              ],
            ),
            SizedBox(height: 10.0),
            Container(
                color: const Color(0xfff5f5f5),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(content, style: TextStyle(fontSize: 14.0)),
                )),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Details", style: TextStyle(fontSize: 14.0)),
              ],
            ),
            SizedBox(height: 20.0),
            SizedBox(
              height: 40.0,
              child: ElevatedButton(
                onPressed: () {
                  if (!_actionTaken) {
                    setState(() {
                      //_actionTaken = !_actionTaken;
                      Navigator.pop(context);
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    !_actionTaken ? Colors.red : Colors.green,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: Text(!_actionTaken ? "Take Action" : "Action Taken",
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
