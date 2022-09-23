import 'package:flutter/material.dart';
import 'package:ira/screens/dashboard/general_feed/feed_post.dart';
import 'package:ira/screens/dashboard/general_feed/new_post/new_post.dart';

class GeneralFeed extends StatefulWidget {
  const GeneralFeed({Key? key}) : super(key: key);

  @override
  State<GeneralFeed> createState() => _GeneralFeedState();
}

class _GeneralFeedState extends State<GeneralFeed> {
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
                            builder: (context) => const NewPost()));
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
            child: ListView.builder(
              itemBuilder: ((BuildContext context, int index) {
                return Column(
                  children: const [
                    FeedPost(),
                    Divider(),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
