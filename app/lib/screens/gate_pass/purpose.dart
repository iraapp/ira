import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:institute_app/screens/gate_pass/gate_pass.dart';
import 'package:institute_app/services/auth.service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PurposeScreen extends StatefulWidget {
  const PurposeScreen({Key? key}) : super(key: key);

  @override
  State<PurposeScreen> createState() => _PurposeScreenState();
}

class _PurposeScreenState extends State<PurposeScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController purposeFieldController = TextEditingController();
  // Create storage
  final storage = const FlutterSecureStorage();

  Future<Map<String, String>> fetchQR() async {
    String? idToken = await storage.read(key: 'idToken');
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/gate_pass/studentStatus'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ' + idToken!
        });

    Map<String, String> mmp = {};

    if (response.statusCode == 200) {
      dynamic decodedBody = jsonDecode(response.body);
      mmp = {
        'qr': decodedBody['hash'],
        'purpose': decodedBody['purpose'],
        'status': decodedBody['status'] ? 'true' : 'false',
      };
    } else {
      mmp['qr'] = 'invalid';
    }

    return Future.value(mmp);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchQR(),
        builder: (
          BuildContext context,
          AsyncSnapshot<dynamic> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return const Scaffold(
                body: Center(child: Text('Please wait its loading...')));
          } else {
            if (snapshot.data['qr'] == 'invalid') {
              return Scaffold(
                body: Stack(children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xff3a82fd),
                            Color(0xff5077d3),
                            Color(0xff3c91c8),
                            Color(0xff72a8ee),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.elliptical(60, 20),
                          bottomRight: Radius.elliptical(60, 20),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 80.0),
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
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    const Text(
                                        'Generate QR Code for going out'),
                                    const SizedBox(
                                      height: 30.0,
                                    ),
                                    TextFormField(
                                      controller: purposeFieldController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please specify the purpose';
                                        }

                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Purpose for going out',
                                      ),
                                    ),
                                    const SizedBox(height: 30.0),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          String? idToken = await storage.read(
                                              key: 'idToken');
                                          final response = await http.post(
                                              Uri.parse(
                                                  'http://10.0.2.2:8000/gate_pass/generate_qr'),
                                              headers: <String, String>{
                                                'Content-Type':
                                                    'application/json; charset=UTF-8',
                                                'Authorization':
                                                    'Token ' + idToken!
                                              },
                                              body: jsonEncode(<String, String>{
                                                'purpose':
                                                    purposeFieldController.text
                                              }));

                                          if (response.statusCode == 200) {
                                            String hash = jsonDecode(
                                                response.body)['hash'];
                                            String purpose = jsonDecode(
                                                response.body)['purpose'];
                                            String status = jsonDecode(
                                                    response.body)['status']
                                                ? 'true'
                                                : 'false';
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    GatePassScreen(
                                                  hash: hash,
                                                  purpose: purpose,
                                                  status: status,
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: const Text('Generate'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                      ],
                    ),
                  ),
                ]),
              );
            } else {
              return GatePassScreen(
                hash: snapshot.data['qr'],
                purpose: snapshot.data['purpose'],
                status: snapshot.data['status'],
              );
            }
          }
        });
  }
}
