import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/gate_pass/purpose.dart';
import 'package:ira/shared/app_scaffold.dart';
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
        MaterialPageRoute(builder: (context) => const PurposeScreen()),
      );
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 50.0),
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                      offset: Offset(
                        0,
                        5,
                      ))
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'QR Code',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
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
                      height: 30.0,
                    ),
                    QrImage(
                      data: hash,
                      version: 3,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
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
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Purpose for gate pass : ',
                        ),
                        Text(
                          purpose,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }
}
