import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/mess/student/mess_mom_model.dart';
import 'package:http/http.dart' as http;

class MOMMessManager extends StatefulWidget {
  MOMMessManager({Key? key}) : super(key: key);
  final secureStorage = const FlutterSecureStorage();
  final String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  @override
  State<MOMMessManager> createState() => _MOMMessManagerState();
}

class _MOMMessManagerState extends State<MOMMessManager> {
  TextEditingController _titleTextCtr = TextEditingController();
  TextEditingController _dateTextCtr = TextEditingController();

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
      print(e);
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF00ABE9),
      appBar: AppBar(
        title: Text(
          "Mess",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Opacity(
                      opacity: 0.0,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("  + Add  "),
                      ),
                    ),
                    Text("MOM",
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    ElevatedButton(
                        onPressed: () async {
                          await showAddMOMDialog();
                        },
                        child: Text("+ Add"),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color?>(
                              Color(0xFF00ABE9)),
                        ))
                  ],
                ),
                SizedBox(height: 20),
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
                                                      onTap: () {},
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
        print(selectedDate);
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
              EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                Text(
                  "Give Title",
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: SizedBox(
                    height: 40.0,
                    child: TextField(
                      controller: _titleTextCtr,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                )
              ]),
              SizedBox(height: 10),
              Row(children: [
                Text(
                  "Date        ",
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(width: 10),
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
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            selectedDate.toLocal().toString().split(' ')[0]),
                      ),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 10),
              Row(children: [
                Text(
                  "Upload PDF",
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(width: 20),
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
                            SnackBar(content: Text('Please select a file')));
                      }
                    },
                    child: Text("Upload"),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color?>(Color(0xFF00ABE9)),
                    )),
                SizedBox(width: 10),
                !_pdfUploaded
                    ? Checkbox(value: false, onChanged: (value) {})
                    : Checkbox(value: true, onChanged: (value) {}),
              ]),
              SizedBox(height: 20),
              SizedBox(
                width: 100.0,
                child: ElevatedButton(
                    onPressed: !_pdfUploaded
                        ? null
                        : () async {
                            // call the api to add the mom
                            final title = _titleTextCtr.text;
                            final description = "no description";
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
                                  SnackBar(content: Text('Error')));
                            }
                          },
                    child: Text("Add"),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color?>(Color(0xFF00ABE9)),
                    )),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel"),
            ),
          ],
        );
      }),
    );
  }
}
