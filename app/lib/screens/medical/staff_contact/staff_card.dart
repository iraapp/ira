import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StaffCard extends StatelessWidget {
  final String name;
  final String designation;
  final String contact;

  const StaffCard({
    Key? key,
    required this.name,
    required this.designation,
    required this.contact,
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
          padding: const EdgeInsets.fromLTRB(30.00, 25.00, 30.0, 25.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            boxShadow: [
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
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
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
                      designation,
                      style: const TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    Text(
                      contact,
                      style: const TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ]),
              IconButton(
                  onPressed: () {
                    _makePhoneCall(contact);
                  },
                  icon: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.call,
                      color: Colors.white,
                      size: 18,
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
