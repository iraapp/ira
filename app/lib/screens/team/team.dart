import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Member {
  String name;
  String designation;
  String profile;
  String linkedIn;
  String github;

  Member(
      {required this.name,
      required this.designation,
      required this.profile,
      required this.linkedIn,
      required this.github});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
        name: json["name"],
        designation: json["designation"],
        profile: json["profile"],
        linkedIn: json["linkedIn_url"],
        github: json["github_url"]);
  }
}

class TeamScreen extends StatefulWidget {
  const TeamScreen({Key? key}) : super(key: key);

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  Future<Map<String, List<Member>>> fetchMembers() async {
    String? idToken = await secureStorage.read(key: 'idToken');
    final response = await http.get(
        Uri.parse(
          baseUrl + '/team/all',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'idToken ' + idToken!
        });

    Map<String, List<Member>> mmp = {};

    if (response.statusCode == 200) {
      dynamic decodedBody = jsonDecode(response.body);

      mmp = {
        'team':
            decodedBody.map<Member>((json) => Member.fromJson(json)).toList()
      };
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
      mmp = {'team': []};
    }

    return Future.value(mmp);
  }

  openUrl(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: FutureBuilder(
                future: fetchMembers(),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, List<Member>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.data == null) {
                    return const CircularProgressIndicator();
                  }

                  List<Member>? team = snapshot.data!['team'];

                  return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 0.0),
                        child: Column(
                          children: [
                            const Text(
                              'Our Team',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height - 200,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: team?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      const Divider(),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.black,
                                            child: CircleAvatar(
                                              radius: 48,
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: ClipOval(
                                                child: Image(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                  baseUrl +
                                                      '/media/images/' +
                                                      team![index].profile,
                                                )),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                team[index].name,
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                team[index].designation,
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () => openUrl(
                                                        team[index].linkedIn),
                                                    icon: CircleAvatar(
                                                      radius: 22,
                                                      backgroundColor:
                                                          Colors.blue,
                                                      child: CircleAvatar(
                                                        radius: 20,
                                                        child: SvgPicture.asset(
                                                            "assets/svgs/LinkedIn_icon_circle.svg"),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () => openUrl(
                                                        team[index].github),
                                                    icon: CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: Image.asset(
                                                          "assets/images/github_icon.png"),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        )),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
