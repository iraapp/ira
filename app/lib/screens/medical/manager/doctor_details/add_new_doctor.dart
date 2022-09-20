import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class AddNewDoctor extends StatefulWidget {
  VoidCallback? updateView = () {};
  int? id;
  String name;
  String specialization;
  String contact;
  String startTime;
  String endTime;
  String date;
  String email;
  String details;

  AddNewDoctor({
    Key? key,
    this.updateView,
    this.id,
    required this.name,
    required this.specialization,
    required this.contact,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.email,
    required this.details,
  }) : super(key: key);

  @override
  State<AddNewDoctor> createState() => _AddNewDoctor();
}

class _AddNewDoctor extends State<AddNewDoctor> {
  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameFieldController = TextEditingController();
  TextEditingController specializationFieldController = TextEditingController();
  TextEditingController contactFieldController = TextEditingController();
  TextEditingController dateFieldController = TextEditingController();
  TextEditingController emailFieldController = TextEditingController();
  TextEditingController detailsFieldController = TextEditingController();
  TextEditingController startTimeFieldController = TextEditingController();
  TextEditingController endTimeFieldController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    nameFieldController.text = widget.name;
    specializationFieldController.text = widget.specialization;
    contactFieldController.text = widget.contact;
    dateFieldController.text = widget.date;
    emailFieldController.text = widget.email;
    startTimeFieldController.text = widget.startTime;
    endTimeFieldController.text = widget.endTime;
    detailsFieldController.text = widget.details;
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    TimeOfDay selectedTime = TimeOfDay.now();
    TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });

    if (picked != null && picked != selectedTime) {
      setState(() {
        controller.text =
            picked.hour.toString() + ":" + picked.minute.toString() + ":00";
      });
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController textEditingController,
  ) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        textEditingController.text = DateFormat("yyyy-MM-dd").format(picked);
      });
    }
  }

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
          SizedBox(
            height: size.height * 0.05,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text("Doctor Details",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: size.width,
            height: size.height * 0.8,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40.0),
                bottomRight: Radius.circular(0.0),
                topLeft: Radius.circular(40.0),
                bottomLeft: Radius.circular(0.0),
              ),
              color: Color(0xfff5f5f5),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 10.0,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    "Add New Doctor",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Form(
                        key: _formKey,
                        child: SizedBox(
                          height: size.height * 0.6,
                          child: ListView(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Name"),
                                  SizedBox(
                                    width: 150,
                                    child: TextFormField(
                                      controller: nameFieldController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please specify the name';
                                        }

                                        return null;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Specialization"),
                                  SizedBox(
                                    width: 150,
                                    child: TextFormField(
                                      controller: specializationFieldController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please specify specialization';
                                        }

                                        return null;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Contact"),
                                  SizedBox(
                                    width: 150,
                                    child: TextFormField(
                                      controller: contactFieldController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please specify your weight';
                                        }

                                        return null;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Timings "),
                                  TextButton(
                                    onPressed: () {
                                      _selectTime(
                                          context, startTimeFieldController);
                                    },
                                    child: Text(
                                        startTimeFieldController.text.isEmpty
                                            ? 'Start Time'
                                            : startTimeFieldController.text),
                                  ),
                                  const Text(" : "),
                                  TextButton(
                                    onPressed: () {
                                      _selectTime(
                                          context, endTimeFieldController);
                                    },
                                    child: Text(
                                        endTimeFieldController.text.isEmpty
                                            ? 'End Time'
                                            : endTimeFieldController.text),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Date"),
                                  TextButton(
                                    onPressed: () {
                                      _selectDate(
                                        context,
                                        dateFieldController,
                                      );
                                    },
                                    child: Text(
                                      dateFieldController.text.isEmpty
                                          ? 'Select date'
                                          : dateFieldController.text,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Email"),
                                  SizedBox(
                                    width: 150,
                                    child: TextFormField(
                                      controller: emailFieldController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please specify your weight';
                                        }

                                        return null;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Details"),
                                  SizedBox(
                                    width: 150,
                                    child: TextFormField(
                                      controller: detailsFieldController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please specify your weight';
                                        }

                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      String? token = await secureStorage.read(
                                          key: 'staffToken');

                                      if (widget.id != null) {
                                        final response = await http.post(
                                            Uri.parse(
                                              baseUrl +
                                                  '/medical/manager/doctor/update',
                                            ),
                                            headers: <String, String>{
                                              'Content-Type':
                                                  'application/json; charset=UTF-8',
                                              'Authorization': token != null
                                                  ? 'Token ' + token
                                                  : '',
                                            },
                                            body: jsonEncode(<String, dynamic>{
                                              'id': widget.id,
                                              'name': nameFieldController.text,
                                              'phone':
                                                  contactFieldController.text,
                                              'specialization':
                                                  specializationFieldController
                                                      .text,
                                              'start_time':
                                                  startTimeFieldController.text,
                                              'end_time':
                                                  endTimeFieldController.text,
                                              'date': dateFieldController.text,
                                              'email':
                                                  emailFieldController.text,
                                              'details':
                                                  detailsFieldController.text
                                            }));
                                        if (response.statusCode == 200) {
                                          Navigator.pop(context);
                                          widget.updateView!();
                                        }
                                      } else {
                                        final response = await http.post(
                                            Uri.parse(
                                              baseUrl +
                                                  '/medical/manager/doctor/',
                                            ),
                                            headers: <String, String>{
                                              'Content-Type':
                                                  'application/json; charset=UTF-8',
                                              'Authorization': token != null
                                                  ? 'Token ' + token
                                                  : '',
                                            },
                                            body: jsonEncode(<String, String>{
                                              'name': nameFieldController.text,
                                              'phone':
                                                  contactFieldController.text,
                                              'specialization':
                                                  specializationFieldController
                                                      .text,
                                              'start_time':
                                                  startTimeFieldController.text,
                                              'end_time':
                                                  endTimeFieldController.text,
                                              'date': dateFieldController.text,
                                              'email':
                                                  emailFieldController.text,
                                              'details':
                                                  detailsFieldController.text
                                            }));
                                        if (response.statusCode == 200) {
                                          Navigator.pop(context);
                                          widget.updateView!();
                                        }
                                      }
                                    }
                                  },
                                  child: const Text("Add"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
