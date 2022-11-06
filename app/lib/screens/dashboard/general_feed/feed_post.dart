import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:ira/screens/dashboard/general_feed/general_feed.dart';
import 'package:ira/screens/dashboard/general_feed/new_post/new_post.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

enum Menu { edit, delete }

// ignore: must_be_immutable
class FeedPost extends StatefulWidget {
  FeedModel data;
  VoidCallback updateView;
  FeedPost({
    Key? key,
    required this.data,
    required this.updateView,
  }) : super(key: key);

  @override
  State<FeedPost> createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {
  late final quill.QuillController _controller;
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];
  final localStorage = LocalStorage('store');
  bool showImages = false;
  final secureStorage = const FlutterSecureStorage();

  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    var myJSON = jsonDecode(widget.data.body);
    _controller = quill.QuillController(
      document: quill.Document.fromJson(myJSON),
      selection: const TextSelection.collapsed(offset: 0),
    );

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);

    for (var file in widget.data.attachments) {
      if (showImages == false && file['extension'] == '.jpg') {
        setState(() {
          showImages = true;
        });
        break;
      }
    }
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
    send!.send([id, status, progress]);
  }

  Future<void> _downloadFile(String fileUrl, String filename) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();

      final taskId = await FlutterDownloader.enqueue(
        url: fileUrl,
        savedDir: baseStorage!.path,
        fileName: filename,
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );

      await FlutterDownloader.open(taskId: taskId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? email = localStorage.getItem('email');

    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 5.0,
              ),
              CircleAvatar(
                backgroundColor: Colors.blue.shade800,
                child: Text(
                  widget.data.authorName[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.data.authorName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            formatTime(widget.data.createdAt),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      if (widget.data.authorEmail == email)
                        PopupMenuButton<Menu>(
                          icon: Icon(
                            Icons.adaptive.more,
                            color: Colors.grey,
                          ),
                          // Callback that sets the selected popup menu item.
                          onSelected: (Menu item) async {
                            if (item == Menu.edit) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewPost(
                                            successCallback: () {
                                              setState(() {});
                                            },
                                            edit: true,
                                            document: quill.Document.fromJson(
                                              jsonDecode(
                                                widget.data.body,
                                              ),
                                            ),
                                            postId: widget.data.id,
                                          )));
                            } else if (item == Menu.delete) {
                              String? idToken =
                                  await secureStorage.read(key: 'idToken');
                              _showDeletionConfirmationDialog(
                                context,
                                idToken: idToken,
                                baseUrl: baseUrl,
                                updateView: widget.updateView,
                                id: widget.data.id,
                              );
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<Menu>>[
                            const PopupMenuItem<Menu>(
                              value: Menu.edit,
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem<Menu>(
                              value: Menu.delete,
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                // const SizedBox(
                //   height: 10.0,
                // ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    // height: 100,
                    child: quill.QuillEditor(
                      controller: _controller,
                      scrollController: ScrollController(),
                      scrollable: true,
                      focusNode: FocusNode(),
                      autoFocus: false,
                      readOnly: true,
                      expands: false,
                      showCursor: false,
                      padding: EdgeInsets.zero,
                      onLaunchUrl: (String url) async {
                        if (!await launchUrl(
                          Uri.parse(url),
                          mode: LaunchMode.externalApplication,
                        )) throw 'Could not launch $url';
                      },
                    )),
                const SizedBox(
                  height: 10.0,
                ),
                showImages
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 250.0,
                        child: ListView.builder(
                            itemCount: widget.data.attachments.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              if (widget.data.attachments[index]['extension'] ==
                                      '.jpg' ||
                                  widget.data.attachments[index]['extension'] ==
                                      '.jpeg' ||
                                  widget.data.attachments[index]['extension'] ==
                                      '.png') {
                                return Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SimpleDialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                children: [
                                                  Image(
                                                    image: CachedNetworkImageProvider(
                                                        baseUrl +
                                                            widget.data
                                                                    .attachments[
                                                                index]['file']),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Image(
                                          image: CachedNetworkImageProvider(
                                              baseUrl +
                                                  widget.data.attachments[index]
                                                      ['file']),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15.0,
                                    ),
                                  ],
                                );
                              }
                              return Container();
                            }),
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: widget.data.attachments.length != 0 ? 40.0 : 0.0,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.data.attachments.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            SizedBox(
                              width: 120.0,
                              child: OutlinedButton(
                                onPressed: () async {
                                  await _downloadFile(
                                    baseUrl +
                                        widget.data.attachments[index]['file'],
                                    widget.data.attachments[index]['filename'],
                                  );
                                },
                                child: Text(
                                  widget.data.attachments[index]['filename'],
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12.0),
                                ),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade800,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20.0,
                            )
                          ],
                        );
                      }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String formatTime(String input) {
    DateTime createdAt = DateTime.parse(input);

    if (createdAt.day == DateTime.now().day) {
      return createdAt.hour.toString() +
          ":" +
          (createdAt.second.toString().length == 1
              ? "0" + createdAt.second.toString()
              : createdAt.second.toString());
    }

    return DateFormat("dd MMM ").format(createdAt) +
        createdAt.hour.toString() +
        ":" +
        createdAt.second.toString();
  }
}

Future<void> _showDeletionConfirmationDialog(
  BuildContext context, {
  String? idToken,
  required int id,
  required String baseUrl,
  required VoidCallback updateView,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            onPressed: () async {
              // print(widget.data.id);
              Map<String, dynamic> body = {
                'id': id.toString(),
              };

              final response =
                  await http.post(Uri.parse(baseUrl + '/feed/delete/'),
                      headers: <String, String>{
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'Authorization': 'idToken ' + idToken!,
                      },
                      encoding: Encoding.getByName('utf-8'),
                      body: body);

              if (response.statusCode == 200) {
                Navigator.pop(context);
                updateView();
              }
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
