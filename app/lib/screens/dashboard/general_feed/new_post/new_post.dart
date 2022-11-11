import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class NewPost extends StatefulWidget {
  quill.Document? document;
  bool edit = false;
  int postId;
  VoidCallback successCallback;

  NewPost(
      {Key? key,
      required this.document,
      required this.successCallback,
      required this.edit,
      required this.postId})
      : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  late quill.QuillController _controller;
  // Create secureStorage
  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];
  List<PlatformFile> files = [];
  bool inProcess = false;

  @override
  initState() {
    super.initState();
    if (widget.document != null) {
      _controller = quill.QuillController(
        document: widget.document!,
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _controller = quill.QuillController.basic();
    }
  }

  Future<bool> _submitPost(quill.Document richDocument) async {
    try {
      String? idToken = await secureStorage.read(key: 'idToken');

      var requestUrl = Uri.parse(baseUrl + '/feed/create/');

      if (widget.edit) {
        requestUrl = Uri.parse(baseUrl + '/feed/update/');
      }

      var request = http.MultipartRequest('POST', requestUrl);
      final headers = {'Authorization': 'idToken ' + idToken!};
      request.headers.addAll(headers);

      if (widget.edit) {
        request.fields['post_id'] = widget.postId.toString();
      }
      request.fields['body'] =
          jsonEncode(_controller.document.toDelta().toJson());
      final plainText = _controller.document.toPlainText();
      request.fields['notification'] = plainText.length > 250
          ? plainText.substring(0, 249) + '...'
          : plainText;

      for (var file in files) {
        request.files
            .add(await http.MultipartFile.fromPath(file.name, file.path!));
      }
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
        title: const Text(
          "Add Post",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0.0,
        actions: [
          TextButton(
            onPressed: () async {
              if (_controller.document.toPlainText().trim().isNotEmpty &&
                  !inProcess) {
                inProcess = true;

                bool response = await _submitPost(_controller.document);

                if (response) {
                  Navigator.pop(context);
                  widget.successCallback();
                }
                inProcess = false;
              }
            },
            child: const Text(
              "Submit",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
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
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30.0,
                    ),
                    quill.QuillToolbar.basic(
                      toolbarIconSize: 20,
                      controller: _controller,
                      showFontFamily: false,
                      multiRowsDisplay: false,
                      toolbarSectionSpacing: 0,
                      showUndo: false,
                      showRedo: false,
                      showFontSize: false,
                      showColorButton: true,
                      showBackgroundColorButton: true,
                      showListBullets: false,
                      showListCheck: false,
                      showListNumbers: false,
                      showCodeBlock: false,
                      showInlineCode: false,
                      showAlignmentButtons: false,
                      showSearchButton: false,
                      showClearFormat: false,
                      showIndent: false,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 200.0,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: quill.QuillEditor.basic(
                        controller: _controller,
                        readOnly: false,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(allowMultiple: true);

                        if (result != null) {
                          setState(() {
                            for (var file in result.files) {
                              files.add(file);
                            }
                          });
                        } else {
                          // User canceled the picker
                        }
                      },
                      child: const Text('Add attachments'),
                    ),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                          itemCount: files.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Text(
                                    files[index].name,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      files.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            );
                          }),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
