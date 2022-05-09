import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;

class ScanGatePass extends StatefulWidget {
  const ScanGatePass({Key? key}) : super(key: key);

  @override
  State<ScanGatePass> createState() => _ScanGatePassState();
}

class _ScanGatePassState extends State<ScanGatePass> {
  final AudioCache player = AudioCache();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];
  final storage = const FlutterSecureStorage();
  bool canCall = true;
  bool _visible = false;

  beep() async {
    player.play('beep.mp3');
  }

  @override
  Widget build(BuildContext context) {
    player.load('beep.mp3');

    return Scaffold(
        body: Column(children: [
      Stack(children: [
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
                    child: Column(
                      children: [
                        const Text(
                          'Scan QR Code',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        SizedBox(
                          height: 300,
                          child: MobileScanner(
                            allowDuplicates: false,
                            onDetect: (barcode, args) async {
                              if (canCall == true) {
                                final String hash = barcode.rawValue!;
                                final String? token =
                                    await storage.read(key: 'guardToken');

                                final response = await http.post(
                                    Uri.parse(baseUrl + '/gate_pass/scan_qr'),
                                    headers: <String, String>{
                                      'Content-Type':
                                          'application/json; charset=UTF-8',
                                      'Authorization':
                                          token != null ? 'Token ' + token : '',
                                    },
                                    body: jsonEncode({
                                      'hash': hash,
                                    }));

                                if (response.statusCode == 200) {
                                  beep();
                                  canCall = false;
                                  setState(() {
                                    _visible = !_visible;
                                  });

                                  Future.delayed(
                                      const Duration(milliseconds: 5000), () {
                                    canCall = true;
                                    setState(() {
                                      _visible = !_visible;
                                    });
                                  });
                                }
                              }
                            },
                          ),
                        ),
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
        ),
      ]),
      AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: _visible ? 1.0 : 0.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
          child: Row(
            children: [
              Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png',
                width: 100.0,
                height: 100.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Ashutosh Chauhan',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    '2020uee0132',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Successfully logged for going out',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    ]));
  }
}
