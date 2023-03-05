import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class StudentCard extends StatelessWidget {
  String name;
  String entryNo;
  String purpose;
  String? inTime;
  String? outTime;
  String contact;
  bool currentlyOut;

  StudentCard({
    Key? key,
    required this.name,
    required this.entryNo,
    required this.purpose,
    required this.inTime,
    required this.outTime,
    required this.contact,
    required this.currentlyOut,
  }) : super(key: key);

  _makePhoneCall(String telphone) async {
    var url = Uri.parse("tel:" + telphone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10.00, 25.00, 20.0, 25.0),
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.all(Radius.circular(5.0)),
            border: Border(
              left: BorderSide(
                width: 10,
                color: currentlyOut ? Colors.red : Colors.white,
              ),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(81, 158, 158, 158),
                offset: Offset(0, 3),
                blurRadius: 3.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 25,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      entryNo,
                      style: const TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        'Purpose: ' + purpose,
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                        softWrap: false,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'Out time : ' + (outTime != null ? outTime! : 'NA'),
                      style: const TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    Text(
                      'In time : ' + (inTime != null ? inTime! : 'NA'),
                      style: const TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ]),
              IconButton(
                  iconSize: 35,
                  onPressed: () {
                    _makePhoneCall(contact);
                  },
                  icon: const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.call,
                      color: Colors.white,
                      size: 25,
                    ),
                  )),
            ],
          ),
        ),
        const SizedBox(
          height: 20.0,
        )
      ],
    );
  }
}
