import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/mess/student/mess_mom_model.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MOMMessManager extends StatefulWidget {
  MOMMessManager({Key? key}) : super(key: key);
  final secureStorage = const FlutterSecureStorage();
  final String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  @override
  State<MOMMessManager> createState() => _MOMMessManagerState();
}

class _MOMMessManagerState extends State<MOMMessManager> {
  final TextEditingController _titleTextCtr = TextEditingController();

  Future<List<MessMOMModel>> _getMessMOMItems() async {
    final String? token = await widget.secureStorage.read(key: 'staffToken');
    final requestUrl = Uri.parse(widget.baseUrl + '/mess/mom');
    final response = await http.get(
      requestUrl,
      headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': token != null ? 'Token ' + token : '',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data
          .map<MessMOMModel>((json) => MessMOMModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<bool> _submitMessMOMItem({
    required String date,
    required String filePath,
    required String title,
    required String description,
  }) async {
    try {
      final String? token = await widget.secureStorage.read(key: 'staffToken');
      final requestUrl = Uri.parse(widget.baseUrl + '/mess/mom');

      var request = http.MultipartRequest('POST', requestUrl);
      final headers = {'Authorization': token != null ? 'Token ' + token : ''};
      request.headers.addAll(headers);
      request.fields['date'] = date;
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        filePath,
        contentType: MediaType('application', 'pdf'),
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text(
          "Mess",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          height: size.height -
              (MediaQuery.of(context).padding.top + kToolbarHeight),
        ),
        child: Container(
          width: double.infinity,
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
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Opacity(
                      opacity: 0.0,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("  + Add  "),
                      ),
                    ),
                    const Text("MOM",
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    ElevatedButton(
                        onPressed: () async {
                          await showAddMOMDialog();
                        },
                        child: const Text("+ Add"),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color?>(Colors.blue),
                        ))
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: FutureBuilder<List<MessMOMModel>>(
                      future: _getMessMOMItems(),
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
                                          decoration: const BoxDecoration(
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
                                                        const SizedBox(
                                                            height: 5),
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
                                      const SizedBox(height: 20),
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
        fileName: "mom" + id,
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

  DateTime selectedDate = DateTime.now();
  String _pdfFilePath = '';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future showAddMOMDialog() async {
    bool _pdfUploaded = false;
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setSte) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                const Text(
                  "Give Title",
                  style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: SizedBox(
                    height: 40.0,
                    child: TextField(
                      controller: _titleTextCtr,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                )
              ]),
              const SizedBox(height: 10),
              Row(children: [
                const Text(
                  "Date        ",
                  style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    height: 40.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text(selectedDate.toLocal().toString().split(' ')[0]),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                const Text(
                  "Upload PDF",
                  style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                    onPressed: () async {
                      final file = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowMultiple: false,
                        allowedExtensions: ['pdf'],
                      );
                      if (file != null) {
                        setSte(() {
                          _pdfUploaded = true;
                          final _pdfFile = file.files.first;
                          _pdfFilePath = _pdfFile.path!;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please select a file')));
                      }
                    },
                    child: const Text("Upload"),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color?>(Colors.blue),
                    )),
                const SizedBox(width: 10),
                !_pdfUploaded
                    ? Checkbox(value: false, onChanged: (value) {})
                    : Checkbox(value: true, onChanged: (value) {}),
              ]),
              const SizedBox(height: 20),
              SizedBox(
                width: 100.0,
                child: ElevatedButton(
                    onPressed: !_pdfUploaded
                        ? null
                        : () async {
                            // call the api to add the mom
                            final title = _titleTextCtr.text;
                            const description = "no description";
                            final date =
                                selectedDate.toLocal().toString().split(' ')[0];
                            final pdf = _pdfFilePath;
                            final bool res = await _submitMessMOMItem(
                                title: title,
                                description: description,
                                date: date,
                                filePath: pdf);
                            if (res) {
                              setState(() {});
                              _titleTextCtr.clear();
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Error')));
                            }
                          },
                    child: const Text("Add"),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color?>(Colors.blue),
                    )),
              )
            ],
          ),
        );
      }),
    );
  }
}
