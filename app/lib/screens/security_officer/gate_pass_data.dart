import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class GatePassData extends StatefulWidget {
  const GatePassData({Key? key}) : super(key: key);

  @override
  State<GatePassData> createState() => _GatePassDataState();
}

class _GatePassDataState extends State<GatePassData> {
  TextEditingController dateinput1 = TextEditingController();
  TextEditingController dateinput2 = TextEditingController();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];
  final secureStorage = const FlutterSecureStorage();
  final uuid = Uuid();

  Future<void> _downloadFile(String fileUrl) async {
    String? staffToken = await secureStorage.read(key: 'staffToken');
    var status = await Permission.storage.request();
    if (status.isGranted) {
      await FlutterDownloader.enqueue(
        url: fileUrl,
        headers: {
          'Authorization': staffToken != null ? 'Token ' + staffToken : '',
        },
        savedDir: '/storage/emulated/0/Download/',
        fileName: "gate_pass_data" + uuid.v1() + ".csv",
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
    }
  }

  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Gate Pass Data'),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(0),
                child: Center(
                    child: TextField(
                  controller: dateinput1, //editing controller of this TextField
                  decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "Start Date" //label text of field
                      ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);

                      setState(() {
                        dateinput1.text =
                            formattedDate; //set output date to TextField value.
                      });
                    }
                  },
                )),
              ),
              Container(
                padding: const EdgeInsets.all(0),
                child: Center(
                    child: TextField(
                  controller: dateinput2,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    labelText: "End Date",
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);

                      setState(() {
                        dateinput2.text =
                            formattedDate; //set output date to TextField value.
                      });
                    }
                  },
                )),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (dateinput1.text != '' && dateinput2.text != '') {
                    await _downloadFile(baseUrl +
                        '/gate_pass/extract?start_date=' +
                        dateinput1.text +
                        '&end_date=' +
                        dateinput2.text);
                  }
                },
                child: const Text('Extract'),
              )
            ],
          ),
        ));
  }
}
