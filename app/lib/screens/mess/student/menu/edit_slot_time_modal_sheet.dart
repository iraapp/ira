import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class EditSlotTimeAlertDialog extends StatefulWidget {
  final String slotId;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  VoidCallback successCallback;

  EditSlotTimeAlertDialog({
    Key? key,
    required this.slotId,
    required this.startTime,
    required this.endTime,
    required this.successCallback,
  }) : super(key: key);

  @override
  State<EditSlotTimeAlertDialog> createState() =>
      _EditSlotTimeAlertDialogState();
}

class _EditSlotTimeAlertDialogState extends State<EditSlotTimeAlertDialog> {
  TimeOfDay wStartTime = TimeOfDay.now();
  TimeOfDay wEndTime = TimeOfDay.now();

  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  @override
  void initState() {
    super.initState();

    wStartTime = widget.startTime;
    wEndTime = widget.endTime;
  }

  Future<void> _selectStartTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: wStartTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });

    if (picked != null) {
      setState(() {
        wStartTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: wEndTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });

    if (picked != null) {
      setState(() {
        wEndTime = picked;
      });
    }
  }

  Future<bool> _updateSlotTime() async {
    final String? token = await secureStorage.read(key: 'staffToken');

    final response = await http.post(
        Uri.parse(baseUrl + '/mess/menu/slot/update'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': token != null ? 'Token ' + token : '',
        },
        body: {
          'slot_id': widget.slotId,
          'start_time': wStartTime.hour.toString() +
              ":" +
              wStartTime.minute.toString() +
              ":00",
          'end_time': wEndTime.hour.toString() +
              ":" +
              wEndTime.minute.toString() +
              ":00",
        });

    if (response.statusCode == 200) {
      return Future.value(true);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Slot Timings'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Timings "),
          TextButton(
              onPressed: () {
                _selectStartTime(context);
              },
              child: Text(wStartTime.format(context))),
          const Text(" : "),
          TextButton(
              onPressed: () {
                _selectEndTime(context);
              },
              child: Text(wEndTime.format(context))),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (wStartTime != widget.startTime || wEndTime != widget.endTime) {
              if (await _updateSlotTime()) {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Icon(
                      Icons.check,
                      size: 40,
                      color: Colors.green,
                    ),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Successfully updated'),
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'))
                    ],
                  ),
                );

                // Invoke success callback to update the view.
                widget.successCallback();
              } else {
                Navigator.of(context).pop();

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Icon(
                      Icons.cancel,
                      size: 40,
                      color: Colors.red,
                    ),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Server Error. Failed to update'),
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'))
                    ],
                  ),
                );
              }
            }
          },
          child: Text(
            'Submit',
            style: TextStyle(
              color:
                  wStartTime != widget.startTime || wEndTime != widget.endTime
                      ? Colors.blue
                      : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
