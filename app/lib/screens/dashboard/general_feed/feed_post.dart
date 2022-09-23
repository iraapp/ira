import 'package:flutter/material.dart';

class FeedPost extends StatelessWidget {
  const FeedPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.red,
            child: Text(
              'A',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Text(
                    "Academic Sec",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "12:05",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                'Lorem Ipsum is simply dummy text of ....',
                style: TextStyle(
                  color: Color.fromARGB(255, 107, 107, 107),
                ),
                maxLines: 4,
                overflow: TextOverflow.fade,
              ),
              const SizedBox(
                height: 10.0,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(
                  "https://img.freepik.com/free-photo/mumbai-skyline-skyscrapers-construction_469504-21.jpg?w=996&t=st=1663874777~exp=1663875377~hmac=8362ff4d702ee8bd0ce8b84296fd8602a605ffd331a479c641b6ea71ded9efd9",
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Text(
                  'Event Name.pdf',
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
