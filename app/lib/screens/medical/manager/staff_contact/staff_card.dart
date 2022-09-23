import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/shared/alert_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class StaffCard extends StatelessWidget {
  final int id;
  final String name;
  final String designation;
  final String contact;
  VoidCallback successCallback;

  StaffCard({
    Key? key,
    required this.id,
    required this.name,
    required this.designation,
    required this.contact,
    required this.successCallback,
  }) : super(key: key);

  _makePhoneCall(String telphone) async {
    var url = Uri.parse("tel:" + telphone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];

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
                Image.asset("assets/icons/staff_contact_profile.png"),
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
              Row(children: [
                InkWell(
                  onTap: () async {
                    String? token = await secureStorage.read(key: 'staffToken');
                    final response = await http.post(
                        Uri.parse(
                          baseUrl + '/medical/manager/staff/delete',
                        ),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                          'Authorization':
                              token != null ? 'Token ' + token : '',
                        },
                        body: jsonEncode(<String, int>{
                          'id': id,
                        }));

                    if (response.statusCode == 200) {
                      successCallback();
                    } else {
                      // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
                    }
                  },
                  child: SizedBox(
                    height: 38.0,
                    child: Image.asset("assets/icons/icon_delete.png"),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _makePhoneCall(contact);
                  },
                  icon: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Image.asset("assets/icons/call.png"),
                  ),
                ),
              ]),
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
