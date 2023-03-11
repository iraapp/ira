import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AddMessItemModalSheet extends StatefulWidget {
  final String menuId;
  final VoidCallback successCallback;

  const AddMessItemModalSheet(
      {Key? key, required this.menuId, required this.successCallback})
      : super(key: key);

  @override
  State<AddMessItemModalSheet> createState() => _AddMessItemModalSheetState();
}

class _AddMessItemModalSheetState extends State<AddMessItemModalSheet> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameFieldController = TextEditingController();
  TextEditingController descriptionFieldController = TextEditingController();

  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  bool veg = true;

  final ImagePicker _picker = ImagePicker();

  String _imagePath = "";
  bool _imageUploaded = false;
  bool imageValidated = true;

  Future<bool> _submitMessItem() async {
    try {
      final String? token = await secureStorage.read(key: 'staffToken');

      final requestUrl = Uri.parse(baseUrl + '/mess/menu/item_add');

      var request = http.MultipartRequest('POST', requestUrl);

      final headers = {'Authorization': token != null ? 'Token ' + token : ''};

      request.headers.addAll(headers);

      request.fields['menu_id'] = widget.menuId;
      request.fields['name'] = nameFieldController.text;
      request.fields['description'] = descriptionFieldController.text;
      request.fields['veg'] = veg.toString();

      request.files
          .add(await http.MultipartFile.fromPath('profile', _imagePath));

      final response = await request.send();

      if (response.statusCode == 200) {
        return Future.value(true);
      } else {
        throw Exception('API Call Failed');
      }
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'Add New Mess Item',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: nameFieldController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please specify name';
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Name",
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 0.0,
                        horizontal: 10.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(75),
                    ],
                    controller: descriptionFieldController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please specify description';
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Description",
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Preference'),
                      DropdownButton<bool>(
                          value: veg,
                          onChanged: (bool? value) {
                            setState(() {
                              veg = value!;
                            });
                          },
                          items: const [
                            DropdownMenuItem<bool>(
                              value: true,
                              child: Text('Veg'),
                            ),
                            DropdownMenuItem<bool>(
                              value: false,
                              child: Text('Non Veg'),
                            ),
                          ]),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Select Image'),
                      ClipOval(
                        child: GestureDetector(
                          onTap: () async {
                            final XFile? image = await _picker.pickImage(
                                source: ImageSource.gallery);
                            if (image != null) {
                              CroppedFile? croppedFile =
                                  await ImageCropper().cropImage(
                                sourcePath: image.path,
                                aspectRatioPresets: [
                                  CropAspectRatioPreset.square,
                                ],
                                maxWidth: 256,
                                maxHeight: 256,
                              );

                              setState(() {
                                _imagePath = croppedFile!.path;
                                _imageUploaded = true;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select an image file'),
                                ),
                              );
                            }
                          },
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: imageValidated
                                ? Colors.blue.shade800
                                : Colors.red,
                            child: _imageUploaded
                                ? CircleAvatar(
                                    radius: 28,
                                    backgroundImage:
                                        FileImage(File(_imagePath)),
                                  )
                                : const CircleAvatar(
                                    radius: 26,
                                    child: ClipOval(
                                        child: Icon(
                                      Icons.image,
                                      size: 30,
                                    )),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              _imagePath.isNotEmpty) {
                            if (await _submitMessItem()) {
                              Navigator.of(context).pop();

                              widget.successCallback();

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
                                      Text('Successfully Added'),
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
                                      Text('Server Error. Failed to add.'),
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

                          if (_imagePath.isEmpty) {
                            setState(() {
                              imageValidated = false;
                            });
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
