import 'package:flutter/material.dart';
import 'package:ira/screens/dashboard/general_feed/feed_post.dart';

class GeneralFeed extends StatefulWidget {
  const GeneralFeed({Key? key}) : super(key: key);

  @override
  State<GeneralFeed> createState() => _GeneralFeedState();
}

class _GeneralFeedState extends State<GeneralFeed> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text(
                      '+ Add',
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.blue,
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
      ),
    );
  }
}
