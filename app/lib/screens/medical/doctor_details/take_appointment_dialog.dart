import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<bool> _requestAppointment(int id, BuildContext context) async {
  const secureStorage = FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];
  String? idToken = await secureStorage.read(key: 'idToken');

  final response = await http.post(
      Uri.parse(
        baseUrl + '/medical/appointment/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'idToken ' + idToken!
      },
      body: jsonEncode({
        'doctor': id,
      }));

  if (response.statusCode == 200) {
    return Future.value(true);
  } else {
    // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
  }

  return Future.value(false);
}

Future takeAppointmentDialog(
  BuildContext context, {
  required int id,
  required String name,
  required String specialization,
  required String contact,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name),
          const SizedBox(height: 5.0),
          Text(specialization),
          const SizedBox(height: 5.0),
          Text(contact),
        ],
      ),
      actions: [
        Center(
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            ),
            onPressed: () async {
              bool result = await _requestAppointment(id, context);

              if (result) {
                Navigator.pop(context);
              }
            },
            child: const Text(
              "Request Appointment",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
