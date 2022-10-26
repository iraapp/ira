import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/login/welcome/add_photo.dart';
import 'package:localstorage/localstorage.dart';

import '../../../util/helpers.dart';

class WelcomeScreen extends StatefulWidget {
  final localStorage = LocalStorage('store');
  WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController mobileFieldController = TextEditingController();
  TextEditingController emergencyFieldController = TextEditingController();
  TextEditingController disciplineFieldController = TextEditingController();
  TextEditingController programmeFieldController = TextEditingController();
  final secureStorage = const FlutterSecureStorage();
  final String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              width: size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40.0),
                  bottomRight: Radius.circular(0.0),
                  topLeft: Radius.circular(40.0),
                  bottomLeft: Radius.circular(0.0),
                ),
                color: Color(0xffffffff),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome, ' +
                          formatDisplayName(
                              widget.localStorage.getItem('displayName')),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Text("Let's get to know more about you"),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Mobile No:'),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: mobileFieldController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please specify your mobile number';
                                }

                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "+91 XXXXXXXXXX",
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0,
                                  horizontal: 10.0,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Text('Emergency Mobile No:'),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: emergencyFieldController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please specify your emergency mobile number';
                                }

                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "+91 XXXXXXXXXX",
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0,
                                  horizontal: 10.0,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Text('Discipline:'),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: disciplineFieldController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please specify your discipline';
                                }

                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Discipline",
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0,
                                  horizontal: 10.0,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Text('Programme:'),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: programmeFieldController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please specify your programme';
                                }

                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Programme",
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0,
                                  horizontal: 10.0,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddPhotoScreen(
                                            mobile: mobileFieldController.text,
                                            emergency:
                                                emergencyFieldController.text,
                                            discipline:
                                                disciplineFieldController.text,
                                            programme:
                                                programmeFieldController.text,
                                          ),
                                        ));
                                  }
                                },
                                child: const Text("Continue"),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
