import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:ira/screens/medical/manager/appointments/appointments_management.dart';
import 'package:http/http.dart' as http;
import 'package:ira/shared/alert_snackbar.dart';

// ignore: must_be_immutable
class AppointmentCard extends StatelessWidget {
  AppointmentManagerModel appointment;
  bool requestsView;
  VoidCallback updateView;

  AppointmentCard({
    Key? key,
    required this.appointment,
    required this.requestsView,
    required this.updateView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(81, 158, 158, 158),
                offset: Offset(0, 3),
                blurRadius: 3.0,
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30.00, 25.00, 10.0, 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Patient : " + appointment.patientName,
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Patient Mail : " + appointment.patientMail,
                            style: const TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                          requestsView
                              ? Text(
                                  "Date : " + (appointment.date ?? ''),
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                  ),
                                )
                              : Container(),
                          requestsView
                              ? Text(
                                  "Time : " +
                                      ((appointment.startTime ?? '') +
                                          ' : ' +
                                          (appointment.endTime ?? '')),
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    requestsView
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showRejectionDialog(context,
                                          id: appointment.id);
                                    },
                                    icon: Image.asset(
                                      'assets/icons/icon_delete.png',
                                    ),
                                  ),
                                  const Text(
                                    "Reject",
                                    style: TextStyle(
                                      fontSize: 11.0,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showConfirmDialog(context,
                                          id: appointment.id,
                                          updateView: updateView);
                                    },
                                    icon: Image.asset(
                                      'assets/icons/appointment_confirm.png',
                                    ),
                                  ),
                                  const Text(
                                    "Confirm",
                                    style: TextStyle(
                                      fontSize: 11.0,
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    appointment.date ?? '',
                                    style: const TextStyle(
                                      fontSize: 11.0,
                                    ),
                                  ),
                                  Text(
                                    appointment.startTime ?? '',
                                    style: const TextStyle(
                                      fontSize: 11.0,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  showConfirmDialog(
                                    context,
                                    id: appointment.id,
                                    updateView: updateView,
                                  );
                                },
                                icon: Image.asset(
                                  'assets/icons/pencil.png',
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding:
                          const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            appointment.doctor.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20.0,
        )
      ],
    );
  }
}

Future<void> _selectTime(
  BuildContext context,
  TextEditingController controller,
  StateSetter setState,
) async {
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
  StateSetter setState,
) async {
  DateTime selectedDate = DateTime.now();
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

Future showConfirmDialog(
  context, {
  required int id,
  required VoidCallback updateView,
}) {
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateFieldController = TextEditingController();
  TextEditingController startTimeFieldController = TextEditingController();
  TextEditingController endTimeFieldController = TextEditingController();
  const secureStorage = FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Date : "),
                        TextButton(
                          onPressed: () {
                            _selectDate(
                              context,
                              dateFieldController,
                              setState,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Timing : "),
                        TextButton(
                          onPressed: () {
                            _selectTime(
                              context,
                              startTimeFieldController,
                              setState,
                            );
                          },
                          child: Text(startTimeFieldController.text.isEmpty
                              ? 'Start Time'
                              : startTimeFieldController.text),
                        ),
                        const Text(" : "),
                        TextButton(
                          onPressed: () {
                            _selectTime(
                              context,
                              endTimeFieldController,
                              setState,
                            );
                          },
                          child: Text(endTimeFieldController.text.isEmpty
                              ? 'End Time'
                              : endTimeFieldController.text),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      actions: [
        Center(
          child: TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                String? token = await secureStorage.read(key: 'staffToken');

                final response = await http.post(
                    Uri.parse(
                      baseUrl + '/medical/manager/appointment/confirm',
                    ),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization': token != null ? 'Token ' + token : '',
                    },
                    body: jsonEncode(<String, dynamic>{
                      'id': id,
                      'start_time': startTimeFieldController.text,
                      'end_time': endTimeFieldController.text,
                      'date': dateFieldController.text,
                    }));

                if (response.statusCode == 200) {
                  updateView();
                  Navigator.pop(context);
                } else {
                  // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
                }
              }
            },
            child: const Text('Send'),
          ),
        ),
      ],
    ),
  );
}

Future showRejectionDialog(
  context, {
  required int id,
}) {
  final _formKey = GlobalKey<FormState>();
  TextEditingController reasonFieldController = TextEditingController();
  const secureStorage = FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Reason : "),
                    SizedBox(
                      width: 150.0,
                      child: TextFormField(
                        controller: reasonFieldController,
                        maxLines: 2,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please specify reason for rejecting';
                          }

                          return null;
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      actions: [
        Center(
          child: TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                String? token = await secureStorage.read(key: 'staffToken');

                final response = await http.post(
                    Uri.parse(
                      baseUrl + '/medical/manager/appointment/reject',
                    ),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization': token != null ? 'Token ' + token : '',
                    },
                    body: jsonEncode(<String, dynamic>{
                      'id': id,
                      'reason': reasonFieldController.text,
                    }));

                if (response.statusCode == 200) {
                  Navigator.pop(context);
                } else {
                  // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
                }
              }
            },
            child: const Text('Send'),
          ),
        ),
      ],
    ),
  );
}
