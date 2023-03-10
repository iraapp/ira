import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ira/screens/mess/student/menu/delete_mess_item_dialog.dart';
import 'package:ira/screens/mess/student/models/mess_menu_model.dart';

class EditDeleteMessItemModalSheet extends StatefulWidget {
  final MessMenuItemModel menuItem;
  final VoidCallback successCallback;

  const EditDeleteMessItemModalSheet({
    Key? key,
    required this.menuItem,
    required this.successCallback,
  }) : super(key: key);

  @override
  State<EditDeleteMessItemModalSheet> createState() =>
      _EditDeleteMessItemModalSheetState();
}

class _EditDeleteMessItemModalSheetState
    extends State<EditDeleteMessItemModalSheet> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameFieldController = TextEditingController();
  TextEditingController descriptionFieldController = TextEditingController();

  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];
  String mediaUrl = FlavorConfig.instance.variables['mediaUrl'];

  bool veg = true;

  final ImagePicker _picker = ImagePicker();

  String _imagePath = "";
  bool _imageUploaded = false;

  Future<bool> _updateMessItem() async {
    try {
      final String? token = await secureStorage.read(key: 'staffToken');

      final requestUrl = Uri.parse(baseUrl + '/mess/menu/item_update');

      var request = http.MultipartRequest('POST', requestUrl);

      final headers = {'Authorization': token != null ? 'Token ' + token : ''};

      request.headers.addAll(headers);

      request.fields['menu_item_id'] = widget.menuItem.id;
      request.fields['name'] = nameFieldController.text;
      request.fields['description'] = descriptionFieldController.text;
      request.fields['veg'] = veg.toString();

      if (_imageUploaded) {
        request.files
            .add(await http.MultipartFile.fromPath('profile', _imagePath));
      }

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
  void initState() {
    super.initState();
    nameFieldController.text = widget.menuItem.name;
    descriptionFieldController.text = widget.menuItem.description;
    veg = widget.menuItem.veg;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Center(
              child: Text(
                'Edit Mess Item',
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
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);
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
                      backgroundColor: Colors.blue.shade800,
                      child: _imageUploaded
                          ? CircleAvatar(
                              radius: 28,
                              backgroundImage: FileImage(File(_imagePath)),
                            )
                          : CircleAvatar(
                              radius: 26,
                              child: ClipOval(
                                child: Image(
                                    image: CachedNetworkImageProvider(
                                  mediaUrl + widget.menuItem.imageUrl,
                                )),
                              ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) => DeleteMessItemDialog(
                              menuItem: widget.menuItem,
                              successCallback: () {
                                widget.successCallback();
                                Navigator.of(context).pop();
                              },
                            ));
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
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
                        if (_formKey.currentState!.validate()) {
                          if (await _updateMessItem()) {
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
                                    Text('Successfully Updated'),
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
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
