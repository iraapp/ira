import 'dart:convert';

import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ComplaintsMess extends StatefulWidget {
  ComplaintsMess({Key? key}) : super(key: key);
  final secureStorage = const FlutterSecureStorage();
  final String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  @override
  State<ComplaintsMess> createState() => _ComplaintsMessState();
}

class _ComplaintsMessState extends State<ComplaintsMess> {
  final List<String> _messFill = ["Fill as Anonymous", "Use your credentials"];
  String _messFillValue = "Fill as Anonymous";
  final List<String> messTypes = [];
  String _messValue = "";
  final List<String> _meals = [
    "Breakfast",
    "Lunch",
    "Snacks",
    "Dinner",
    "General"
  ];
  String _mealsValue = "Breakfast";
  String _description = "";
  String _imagePath = "";

  Future<bool> _submitMessComplaint(String description, String messType,
      String messMeal, String filePath) async {
    try {
      String? idToken = await widget.secureStorage.read(key: 'idToken');
      final requestUrl = Uri.parse(widget.baseUrl + '/mess/complaint');

      var request = http.MultipartRequest('POST', requestUrl);
      final headers = {'Authorization': 'idToken ' + idToken!};
      request.headers.addAll(headers);
      request.fields['complaint'] = description;
      request.fields['mess_type'] = messType;
      request.fields['mess_meal'] = messMeal;
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        filePath,
        contentType: MediaType('image', 'jpeg'),
      ));
      final response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
        throw Exception('API Call Failed');
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> _getMessTypes() async {
    String? idToken = await widget.secureStorage.read(key: 'idToken');

    final requestUrl = Uri.parse(widget.baseUrl + '/mess/list/');
    final response = await http.get(
      requestUrl,
      headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': 'idToken ' + idToken!
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (var item in data) {
        messTypes.add(item['name']);
      }
      setState(() {
        _messValue = messTypes.isNotEmpty ? messTypes[0] : '';
      });
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
      throw Exception('API Call Failed');
    }
  }

  final ImagePicker _picker = ImagePicker();
  bool _imageUploaded = false;

  @override
  void initState() {
    super.initState();
    _getMessTypes();
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
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(
            height: size.height -
                (MediaQuery.of(context).padding.top + kToolbarHeight),
          ),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xfff5f5f5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Complaint",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 0.0),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 10.0),
                          child: DropdownButton<String>(
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            value: _messFillValue,
                            items: _messFill.map((String items) {
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
                              setState(() {
                                _messFillValue = value!;
                              });
                            },
                            borderRadius: BorderRadius.circular(10.0),
                            isExpanded: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Mess:",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  )),
                              SizedBox(
                                width: 150,
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
                                    setState(() {
                                      _messValue = value!;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(10.0),
                                  isExpanded: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Meal:",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  )),
                              SizedBox(
                                width: 150,
                                child: DropdownButton<String>(
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                  value: _mealsValue,
                                  items: _meals.map((String items) {
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
                                    setState(() {
                                      _mealsValue = value!;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(10.0),
                                  isExpanded: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Row(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Text("Description:",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: TextField(
                            maxLines: 5,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  //borderRadius: BorderRadius.circular(10.0),
                                  ),
                              hintText: "Description",
                            ),
                            onChanged: (value) {
                              setState(() {
                                _description = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    final XFile? image = await _picker
                                        .pickImage(source: ImageSource.gallery);
                                    if (image != null) {
                                      setState(() {
                                        _imagePath = image.path;
                                        _imageUploaded = true;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Please select an image file')));
                                    }
                                  },
                                  child: const Text("Upload Image"),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0.0)),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color?>(
                                            Colors.blue),
                                  )),
                              const SizedBox(width: 10),
                              !_imageUploaded
                                  ? Checkbox(
                                      value: false, onChanged: (value) {})
                                  : Checkbox(
                                      value: true, onChanged: (value) {}),
                            ]),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 140.0,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      if (_imagePath.isNotEmpty) {
                                        final res = await _submitMessComplaint(
                                          _description.toString(),
                                          _messValue,
                                          _mealsValue,
                                          _imagePath,
                                        );
                                        if (res) {
                                          await showFeedbackDialog(context,
                                              title: "Thank you",
                                              content:
                                                  "We wil try to improve our service",
                                              defaultActionText: "Close");
                                          Navigator.of(context).pop();
                                        }
                                      }
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                      ),
                                    ),
                                    child: const Text("Submit",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                        ))),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future showFeedbackDialog(
  BuildContext context, {
  required String title,
  required String content,
  required String defaultActionText,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10.0),
          SizedBox(
              height: 100.0,
              child: Image.asset("assets/images/icon _tick circle.png")),
          const SizedBox(height: 20.0),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(content),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(defaultActionText),
        ),
      ],
    ),
  );
}
