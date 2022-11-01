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

  String discipline = "Bioscience and Bioengineering";
  String programme = "B Tech";

  List<DropdownMenuItem<String>> disciplines = const [
    DropdownMenuItem(
        child: Text("Bioscience and Bioengineering"),
        value: "Bioscience and Bioengineering"),
    DropdownMenuItem(
        child: Text("Computer Science Engineering"),
        value: "Computer Science Engineering"),
    DropdownMenuItem(
        child: Text("Chemical Engineering"), value: "Chemical Engineering"),
    DropdownMenuItem(
        child: Text("Civil Engineering"), value: "Civil Engineering"),
    DropdownMenuItem(
        child: Text("Electrical Engineering"), value: "Electrical Engineering"),
    DropdownMenuItem(
        child: Text("Humanities and Social Sciences"),
        value: "Humanities and Social Sciences"),
    DropdownMenuItem(child: Text("Mathematics"), value: "Mathematics"),
    DropdownMenuItem(
        child: Text("Materials Engineering"), value: "Materials Engineering"),
    DropdownMenuItem(
        child: Text("Mechanical Engineering"), value: "Mechanical Engineering"),
    DropdownMenuItem(child: Text("Physics"), value: "Physics"),
  ];

  List<DropdownMenuItem<String>> programmes = const [
    DropdownMenuItem(child: Text("B Tech"), value: "B Tech"),
    DropdownMenuItem(child: Text("M Tech"), value: "M Tech"),
    DropdownMenuItem(child: Text("Ph. D"), value: "Ph. D"),
  ];

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
                            DropdownButton(
                              value: discipline,
                              onChanged: (String? newValue) {
                                setState(() {
                                  discipline = newValue!;
                                });
                              },
                              items: disciplines,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Text('Programme:'),
                            const SizedBox(
                              height: 5,
                            ),
                            DropdownButton(
                              value: programme,
                              onChanged: (String? newValue) {
                                setState(() {
                                  programme = newValue!;
                                });
                              },
                              items: programmes,
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
