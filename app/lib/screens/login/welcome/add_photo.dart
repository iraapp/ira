import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ira/screens/dashboard/dashboard.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;

import '../../../util/helpers.dart';

// ignore: must_be_immutable
class AddPhotoScreen extends StatefulWidget {
  final localStorage = LocalStorage('store');
  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  String mobile;
  String emergency;
  String discipline;
  String programme;

  AddPhotoScreen({
    Key? key,
    required this.mobile,
    required this.emergency,
    required this.discipline,
    required this.programme,
  }) : super(key: key);

  @override
  State<AddPhotoScreen> createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  final ImagePicker _picker = ImagePicker();

  String _imagePath = "";
  bool _imageUploaded = false;

  Future<bool> _postStudentData() async {
    try {
      String? idToken = await widget.secureStorage.read(key: 'idToken');

      final requestUrl = Uri.parse(widget.baseUrl + '/user_profile/student');

      var request = http.MultipartRequest('POST', requestUrl);
      final headers = {'Authorization': 'idToken ' + idToken!};
      request.headers.addAll(headers);
      request.fields['mobile'] = widget.mobile;
      request.fields['emergency'] = widget.emergency;
      request.fields['discipline'] = widget.discipline;
      request.fields['programme'] = widget.programme;

      request.files
          .add(await http.MultipartFile.fromPath('profile', _imagePath));

      final response = await request.send();
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('API Call Failed');
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
                  vertical: 40.0,
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
                    const Text("One last step"),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: GestureDetector(
                              onTap: () async {
                                final XFile? image = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                if (image != null) {
                                  setState(() {
                                    _imagePath = image.path;
                                    _imageUploaded = true;
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Please select an image file'),
                                    ),
                                  );
                                }
                              },
                              child: CircleAvatar(
                                radius: 82,
                                backgroundColor: Colors.blue.shade800,
                                child: _imageUploaded
                                    ? CircleAvatar(
                                        radius: 78,
                                        backgroundImage:
                                            FileImage(File(_imagePath)),
                                      )
                                    : const CircleAvatar(
                                        radius: 78,
                                        child: ClipOval(
                                            child: Icon(
                                          Icons.person,
                                          size: 130,
                                        )),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_imagePath.isNotEmpty) {
                                  if (await _postStudentData()) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Dashboard(
                                            role: 'student',
                                          ),
                                        ));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Please upload a profile image")));
                                }
                              },
                              child: const Text("Continue"),
                            ),
                          )
                        ],
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
