import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:http/http.dart' as http;
import 'package:ira/screens/gate_pass/gate_pass.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PurposeScreen extends StatefulWidget {
  const PurposeScreen({Key? key}) : super(key: key);

  @override
  State<PurposeScreen> createState() => _PurposeScreenState();
}

class _PurposeScreenState extends State<PurposeScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController purposeFieldController = TextEditingController();
  // Create secureStorage
  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  Future<Map<String, String>> fetchQR() async {
    String? idToken = await secureStorage.read(key: 'idToken');
    final response = await http.get(
        Uri.parse(
          baseUrl + '/gate_pass/studentStatus',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'idToken ' + idToken!
        });

    Map<String, String> mmp = {};

    if (response.statusCode == 200) {
      dynamic decodedBody = jsonDecode(response.body);
      mmp = {
        'qr': decodedBody['hash'],
        'purpose': decodedBody['purpose'],
        'status': decodedBody['status'] ? 'true' : 'false',
      };
    } else if (response.statusCode != 401 || response.statusCode != 404) {
      mmp['qr'] = 'invalid';
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
    }

    return Future.value(mmp);
  }

  late Future _fetchQR;

  @override
  void initState() {
    super.initState();
    _fetchQR = fetchQR();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: _fetchQR,
        builder: (
          BuildContext context,
          AsyncSnapshot<dynamic> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            if (snapshot.data['qr'] == 'invalid') {
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
                body: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                      height: size.height -
                          (MediaQuery.of(context).padding.top + kToolbarHeight),
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xfff5f5f5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 50.0),
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 2.0,
                                      offset: Offset(
                                        0,
                                        2,
                                      ))
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: TextFormField(
                                  controller: purposeFieldController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please specify the purpose';
                                    }

                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: '  Purpose for going out',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                String? idToken =
                                    await secureStorage.read(key: 'idToken');
                                final response = await http.post(
                                    Uri.parse(
                                      baseUrl + '/gate_pass/generate_qr',
                                    ),
                                    headers: <String, String>{
                                      'Content-Type':
                                          'application/json; charset=UTF-8',
                                      'Authorization': 'idToken ' + idToken!
                                    },
                                    body: jsonEncode(<String, String>{
                                      'purpose': purposeFieldController.text
                                    }));

                                if (response.statusCode == 200) {
                                  String hash =
                                      jsonDecode(response.body)['hash'];
                                  String purpose =
                                      jsonDecode(response.body)['purpose'];
                                  String status =
                                      jsonDecode(response.body)['status']
                                          ? 'true'
                                          : 'false';

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GatePassScreen(
                                        hash: hash,
                                        purpose: purpose,
                                        status: status,
                                      ),
                                    ),
                                  );
                                } else {
                                  // ScaffoldMessenger.of(context)
                                  //     .showSnackBar(alertSnackbar);
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
