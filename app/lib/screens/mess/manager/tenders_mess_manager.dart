import 'dart:convert';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:isolate';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ira/screens/mess/student/mess_tender_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class TendersMessManager extends StatefulWidget {
  TendersMessManager({Key? key}) : super(key: key);
  final secureStorage = const FlutterSecureStorage();
  final String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  @override
  State<TendersMessManager> createState() => _TendersMessManagerState();
}

class _TendersMessManagerState extends State<TendersMessManager> {
  bool _isActive = true;
  final TextEditingController _titleTextCtr = TextEditingController();
  final TextEditingController _descriptionTextCtr = TextEditingController();

  Future<List<MessTenderModel>> _getMessTenderActiveItems() async {
    final String? token = await widget.secureStorage.read(key: 'staffToken');
    final requestUrl = Uri.parse(widget.baseUrl + '/mess/tender');
    final response = await http.get(
      requestUrl,
      headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': token != null ? 'Token ' + token : '',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<MessTenderModel> _activeItems = [];
      for (var d in data) {
        final item = MessTenderModel.fromJson(d);
        if (item.archived == false) {
          _activeItems.add(item);
        }
      }
      return _activeItems;
    }
    // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
    throw Exception('API Call failed');
  }

  Future<List<MessTenderModel>> _getMessTenderArchivedItems() async {
    final String? token = await widget.secureStorage.read(key: 'staffToken');

    final requestUrl = Uri.parse(widget.baseUrl + '/mess/tender');
    final response = await http.get(
      requestUrl,
      headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': token != null ? 'Token ' + token : '',
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
    }
    // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
    throw Exception('API Call Failed');
  }

  Future<bool> _submitMessTenderItem({
    required String date,
    required String filePath,
    required String title,
    required String description,
    required String contractor,
  }) async {
    try {
      final String? token = await widget.secureStorage.read(key: 'staffToken');
      final requestUrl = Uri.parse(widget.baseUrl + '/mess/tender');

      var request = http.MultipartRequest('POST', requestUrl);
      final headers = {'Authorization': token != null ? 'Token ' + token : ''};
      request.headers.addAll(headers);
      request.fields['date'] = date;
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['contractor'] = contractor;
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        filePath,
        contentType: MediaType('application', 'pdf'),
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('API call failed');
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> _makeTenderArchive(int id) async {
    final String? token = await widget.secureStorage.read(key: 'staffToken');

    final requestUrl = Uri.parse(widget.baseUrl + '/mess/tender/archive/$id/');
    final response = await http.put(
      requestUrl,
      headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': token != null ? 'Token ' + token : '',
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
    }
  }

  final Set<String> messTypes = {"Choose Mess"};
  String _messValue = "Choose Mess";

  Future<void> _getMessTypes() async {
    final String? token = await widget.secureStorage.read(key: 'staffToken');

    final requestUrl = Uri.parse(widget.baseUrl + '/mess/get/mess');
    final response = await http.get(
      requestUrl,
      headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': token != null ? 'Token ' + token : '',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (var item in data) {
        messTypes.add(item['name']);
      }
      setState(() {});
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
      throw Exception('API Call Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text(
          "Mess Tender",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        centerTitle: true,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
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
                if (_isActive)
                  Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          await showAddTenderDialog();
                        },
                        child: const Text("   + Add   "),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color?>(Colors.blue),
                        )),
                  ),
                const SizedBox(height: 10),
                if (!_isActive)
                  const Text("Download old tenders here",
                      style: TextStyle(
                        fontSize: 14.0,
                      )),
                const SizedBox(height: 10),
                Expanded(
                  child: FutureBuilder<List<MessTenderModel>>(
                      future: _isActive
                          ? _getMessTenderActiveItems()
                          : _getMessTenderArchivedItems(),
                      builder: (_, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text("No data available"),
                              );
                            }
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
                                                        Text(data.description,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black54,
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
                                                    Row(
                                                      children: [
                                                        if (_isActive)
                                                          InkWell(
                                                            onTap: () async {
                                                              await _makeTenderArchive(
                                                                  int.parse(
                                                                      data.id));
                                                              setState(() {});
                                                            },
                                                            child: SizedBox(
                                                              height: 38.0,
                                                              child: Image.asset(
                                                                  "assets/icons/icon_delete.png"),
                                                            ),
                                                          ),
                                                        const SizedBox(
                                                            width: 10),
                                                        InkWell(
                                                          onTap: () async {
                                                            if (data.file !=
                                                                'null') {
                                                              await _downloadFile(
                                                                  widget.baseUrl +
                                                                      data.file,
                                                                  data.id);
                                                            }
                                                          },
                                                          child: SizedBox(
                                                            height: 38.0,
                                                            child: Image.asset(
                                                                "assets/icons/download_cloud.png"),
                                                          ),
                                                        ),
                                                      ],
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
        fileName: "tender" + id,
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
    _getMessTypes();

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

  Future showAddTenderDialog() async {
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
                  "Tender Title",
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
                  "Date             ",
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  "Mess Name",
                  style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: SizedBox(
                    width: 150.0,
                    child: DropdownButton<String>(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      value: _messValue,
                      items: messTypes.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(
                            items,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setSte(() {
                          _messValue = value!;
                        });
                      },
                      borderRadius: BorderRadius.circular(10.0),
                      isExpanded: true,
                    ),
                  ),
                )
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
                            // call the api to add the tender
                            final title = _titleTextCtr.text;
                            final description = _descriptionTextCtr.text;
                            final date =
                                selectedDate.toLocal().toString().split(' ')[0];
                            final pdf = _pdfFilePath;
                            final bool res = await _submitMessTenderItem(
                                title: title,
                                description: description,
                                date: date,
                                filePath: pdf,
                                contractor: "nill");
                            if (res) {
                              setState(() {});
                              _titleTextCtr.clear();
                              _descriptionTextCtr.clear();
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
