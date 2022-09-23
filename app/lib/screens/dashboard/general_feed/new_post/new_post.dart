import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final quill.QuillController _controller = quill.QuillController.basic();

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
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40.0),
                bottomRight: Radius.circular(0.0),
                topLeft: Radius.circular(40.0),
                bottomLeft: Radius.circular(0.0),
              ),
              color: Color(0xfff5f5f5),
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
                      controller: _controller,
                      showFontFamily: false,
                      multiRowsDisplay: false,
                      toolbarSectionSpacing: 0,
                      showUndo: false,
                      showRedo: false,
                      showFontSize: false,
                      showColorButton: false,
                      showBackgroundColorButton: false,
                      showListBullets: false,
                      showListCheck: false,
                      showListNumbers: false,
                      showCodeBlock: false,
                      showInlineCode: false,
                      showAlignmentButtons: false,
                      showSearchButton: false,
                      showClearFormat: false,
                      showIndent: false,
                      embedButtons: FlutterQuillEmbeds.buttons(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 300.0,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: quill.QuillEditor.basic(
                        controller: _controller,
                        readOnly: false,
                        embedBuilders: FlutterQuillEmbeds.builders(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // print(_controller.document.toDelta().toJson());
                        },
                        child: const Text("Submit"),
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
