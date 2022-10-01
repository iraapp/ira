import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/dashboard/general_feed/feed_post.dart';
import 'package:ira/screens/dashboard/general_feed/new_post/new_post.dart';
import 'package:http/http.dart' as http;
import 'package:ira/screens/dashboard/general_feed/panel_state_stream.dart';
import 'package:provider/provider.dart';

class FeedModel {
  String body;
  String authorName;
  String authorEmail;
  dynamic attachments;

  FeedModel(
      {required this.body,
      required this.authorName,
      required this.authorEmail,
      required this.attachments});

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    return FeedModel(
        body: json['body'].toString(),
        authorName: json['user']['first_name'].toString() +
            ' ' +
            json['user']['last_name'].toString(),
        authorEmail: json['user']['email'],
        attachments: json['attachments']);
  }
}

class GeneralFeed extends StatefulWidget {
  const GeneralFeed({Key? key}) : super(key: key);

  @override
  State<GeneralFeed> createState() => _GeneralFeedState();
}

class _GeneralFeedState extends State<GeneralFeed> {
  // Create secureStorage
  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  Future<List<FeedModel>> fetchFeed() async {
    String? idToken = await secureStorage.read(key: 'idToken');
    final response = await http.get(
        Uri.parse(
          baseUrl + '/feed/feed/',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'idToken ' + idToken!
        });

    if (response.statusCode == 200) {
      List decodedBody = jsonDecode(response.body);
      return decodedBody.map((json) => FeedModel.fromJson(json)).toList();
    } else if (response.statusCode != 401 || response.statusCode != 404) {
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
    }

    return Future.value([]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Center(
            child: Container(
              width: 30,
              height: 5,
              margin: const EdgeInsets.only(top: 10.0, bottom: 5.0),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewPost(
                                  successCallback: () {
                                    setState(() {});
                                  },
                                )));
                  },
                  child: const Text(
                    '+ Add',
                    style: TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              displacement: 15.0,
              color: Colors.white,
              backgroundColor: Colors.blue,
              onRefresh: () async {
                setState(() {});
              },
              child: FutureBuilder(
                future: fetchFeed(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<FeedModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return FeedList(
                    feeds: snapshot.data!,
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 100.0,
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class FeedList extends StatefulWidget {
  List<FeedModel> feeds;
  FeedList({Key? key, required this.feeds}) : super(key: key);

  @override
  State<FeedList> createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  bool heightState = false;

  @override
  Widget build(BuildContext context) {
    PanelStateStream panelStateStream = Provider.of(context);

    if (heightState != panelStateStream.state) {
      setState(() {
        heightState = panelStateStream.state;
      });
    }

    panelStateStream.stream.listen((event) {
      if (heightState != panelStateStream.state) {
        setState(() {
          heightState = panelStateStream.state;
        });
      }
    });

    return SizedBox(
      height: MediaQuery.of(context).size.height - (heightState ? 0 : 350),
      child: ListView.builder(
        itemCount: widget.feeds.length,
        itemBuilder: ((BuildContext context, int index) {
          return Column(
            children: [
              FeedPost(data: widget.feeds[index]),
              const Divider(),
            ],
          );
        }),
      ),
    );
  }
}
