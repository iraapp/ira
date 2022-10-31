import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/gate_pass/purpose.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class GatePassScreen extends StatelessWidget {
  String hash;
  String purpose;
  String status;
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];
  final secureStorage = const FlutterSecureStorage();

  GatePassScreen({
    Key? key,
    required this.hash,
    required this.purpose,
    required this.status,
  }) : super(key: key);

  void destroyQr(BuildContext context) async {
    String? idToken = await secureStorage.read(key: 'idToken');
    final response =
        await http.post(Uri.parse(baseUrl + '/gate_pass/delete_qr'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'idToken ' + idToken!,
            },
            body: jsonEncode({
              'hash': hash,
            }));

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PurposeScreen()),
      );
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text(
          "Gate Pass",
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
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40.0),
              bottomRight: Radius.circular(0.0),
              topLeft: Radius.circular(40.0),
              bottomLeft: Radius.circular(0.0),
            ),
            color: Color(0xfff5f5f5),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Purpose for gate pass : ',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        purpose,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Opacity(
                      opacity: 0.0,
                      child: IconButton(
                        onPressed: () => destroyQr(context),
                        color: Colors.black,
                        icon: const Icon(Icons.delete),
                      )),
                  SizedBox(
                    width: 130.0,
                    height: 35.0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: status == 'false' ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          status == 'false'
                              ? 'Inside Campus'
                              : 'Outside Campus',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  status == 'false'
                      ? IconButton(
                          onPressed: () => destroyQr(context),
                          color: Colors.black,
                          icon: const Icon(Icons.delete),
                        )
                      : Container()
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        QrImage(
                          data: hash,
                          version: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
