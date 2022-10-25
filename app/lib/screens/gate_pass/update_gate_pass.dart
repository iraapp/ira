import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ira/shared/app_scaffold.dart';

// ignore: must_be_immutable
class UpdateGatePass extends StatelessWidget {
  final String hash;
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];
  final secureStorage = const FlutterSecureStorage();

  UpdateGatePass({
    Key? key,
    required this.hash,
  }) : super(key: key);

  Future<String> updateQR() async {
    final String? token = await secureStorage.read(key: 'staffToken');

    final response = await http.post(Uri.parse(baseUrl + '/gate_pass/scan_qr'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token != null ? 'Token ' + token : '',
        },
        body: jsonEncode({
          'hash': hash,
        }));

    if (response.statusCode == 200) {
      return Future.value(json.decode(response.body));
    } else {
      return Future.value('failed');
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
              width: MediaQuery.of(context).size.width * 0.9,
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
                child: FutureBuilder(
                    future: updateQR(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Column(
                        children: [
                          const Text(
                            'QR Scanned successfully',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          snapshot.data != 'failed'
                              ? const Icon(
                                  Icons.check_circle_outline_outlined,
                                  color: Colors.green,
                                  size: 200.0,
                                )
                              : const Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.red,
                                  size: 200.0,
                                ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            snapshot.data,
                            style: const TextStyle(fontSize: 17.0),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Scan new'),
                          )
                        ],
                      );
                    }),
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
