import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ira/screens/mess/factories/mess.dart';
import 'package:ira/screens/mess/student/mess_tender_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class TenderMess extends StatefulWidget {
  TenderMess({Key? key}) : super(key: key);
  final secureStorage = const FlutterSecureStorage();
  final String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  @override
  State<TenderMess> createState() => _TenderMessState();
}

class _TenderMessState extends State<TenderMess> {
  bool _isActive = true;

  Future<List<MessTenderModel>> _getMessTenderActiveItems() async {
    String? idToken = await widget.secureStorage.read(key: 'idToken');

    final requestUrl = Uri.parse(widget.baseUrl + '/mess/tender');
    final response = await http.get(
      requestUrl,
      headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': 'idToken ' + idToken!
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data
          .map<MessTenderModel>((json) => MessTenderModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<List<MessTenderModel>> _getMessTenderArchivedItems() async {
    String? idToken = await widget.secureStorage.read(key: 'idToken');

    final requestUrl = Uri.parse(widget.baseUrl + '/mess/tender');
    final response = await http.get(
      requestUrl,
      headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': 'idToken ' + idToken!
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<MessTenderModel> _archivedItems = [];
      for (var d in data) {
        final item = MessTenderModel.fromJson(d);
        if (item.archived == true) {
          _archivedItems.add(item);
        }
      }
      return _archivedItems;
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF00ABE9),
      appBar: AppBar(
        title: Text(
          "Mess Tender",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF00ABE9),
        elevation: 0.0,
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          height: size.height -
              (MediaQuery.of(context).padding.top + kToolbarHeight),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40.0),
              bottomRight: Radius.circular(0.0),
              topLeft: Radius.circular(40.0),
              bottomLeft: Radius.circular(0.0),
            ),
            color: const Color(0xfff5f5f5),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          //TODO: Handle Active
                          setState(() {
                            _isActive = true;
                          });
                        },
                        child: Text("Active",
                            style: TextStyle(
                              decoration:
                                  _isActive ? TextDecoration.underline : null,
                              color: _isActive ? Colors.blue : Colors.black,
                              fontSize: 16,
                            )),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isActive = false;
                          });
                        },
                        child: Text("Archived",
                            style: TextStyle(
                              fontSize: 16,
                              color: !_isActive ? Colors.blue : Colors.black,
                              decoration:
                                  !_isActive ? TextDecoration.underline : null,
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                if (!_isActive)
                  Text("Download old tenders here",
                      style: TextStyle(
                        fontSize: 14.0,
                      )),
                SizedBox(height: 10),
                Expanded(
                  child: FutureBuilder<List<MessTenderModel>>(
                      future: _isActive
                          ? _getMessTenderActiveItems()
                          : _getMessTenderArchivedItems(),
                      builder: (_, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (BuildContext context, int index) {
                                final data = snapshot.data![index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Column(
                                    children: [
                                      Container(
                                          height: size.height * 0.13,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10.0),
                                              bottomRight:
                                                  Radius.circular(10.0),
                                              topLeft: Radius.circular(10.0),
                                              bottomLeft: Radius.circular(10.0),
                                            ),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey,
                                                offset:
                                                    Offset(0.0, 1.0), //(x,y)
                                                blurRadius: 1.0,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(data.title,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                        SizedBox(height: 5),
                                                        Text(data.description,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black54,
                                                            )),
                                                        SizedBox(height: 5),
                                                        Text(data.date,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black54,
                                                            )),
                                                      ],
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        if (data.file !=
                                                            'null') {
                                                          await _downloadFile(
                                                              data.file,
                                                              data.id);
                                                        }
                                                      },
                                                      child: SizedBox(
                                                        height: 38.0,
                                                        child: Image.asset(
                                                            "assets/icons/download_cloud.png"),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                      SizedBox(height: 20),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _downloadFile(String fileUrl, String id) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();
      await FlutterDownloader.enqueue(
        url: fileUrl,
        savedDir: baseStorage!.path,
        fileName: "tender" + id,
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
    }
  }

  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
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
}
