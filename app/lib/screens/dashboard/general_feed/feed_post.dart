import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:ira/screens/dashboard/general_feed/general_feed.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class FeedPost extends StatefulWidget {
  FeedModel data;
  FeedPost({Key? key, required this.data}) : super(key: key);

  @override
  State<FeedPost> createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {
  late final quill.QuillController _controller;
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];
  bool showImages = false;

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade800,
            child: Text(
              widget.data.author[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.data.author,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  const Text(
                    "12:05",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  // height: 100,
                  child: quill.QuillEditor(
                    controller: _controller,
                    scrollController: ScrollController(),
                    scrollable: true,
                    focusNode: FocusNode(),
                    autoFocus: true,
                    readOnly: true,
                    expands: false,
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
                                              children: [
                                                Image(
                                                  image: CachedNetworkImageProvider(
                                                      baseUrl +
                                                          widget.data
                                                                  .attachments[
                                                              index]['file']),
                                                  width: MediaQuery.of(context)
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
                height: 40.0,
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
          )
        ],
      ),
    );
  }
}
