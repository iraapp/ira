import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MaintenanceContactCard extends StatelessWidget {
  final String name;
  final String contact;
  final String designation;
  final String endTime;
  final String location;
  final String startTime;

  const MaintenanceContactCard({
    Key? key,
    required this.name,
    required this.contact,
    required this.designation,
    required this.endTime,
    required this.location,
    required this.startTime,
  }) : super(key: key);

  _makingPhoneCall(String telphone) async {
    var url = Uri.parse("tel:" + telphone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              color: Color(0xff3a82fd),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Center(
              child: Text(
                designation,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              color: Color.fromARGB(72, 58, 129, 253),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Timings: " +
                        startTime +
                        " Hours to " +
                        endTime +
                        " Hours"),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text("Location: " + location),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text("Name: " + name),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xff3a82fd),
                      child: IconButton(
                        onPressed: () {
                          _makingPhoneCall(contact);
                        },
                        icon: const Icon(
                          Icons.call,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
