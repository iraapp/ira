import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class FeedbackMess extends StatefulWidget {
  FeedbackMess({Key? key}) : super(key: key);
  final secureStorage = const FlutterSecureStorage();
  final String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  @override
  State<FeedbackMess> createState() => _FeedbackMessState();
}

class _FeedbackMessState extends State<FeedbackMess> {
  final List<String> _messFill = ["Fill as Anonymous", "Use your credentials"];
  String _messFillValue = "Fill as Anonymous";
  final List<String> _messTypes = ["1B Mess", "120 Mess", "Girls Mess"];
  String _messValue = "1B Mess";
  final List<String> _messMeals = [
    "Breakfast",
    "Lunch",
    "Snacks",
    "Dinner",
    "General"
  ];
  String _mealsValue = "Breakfast";

  String? _description;

  Future<dynamic> _submitFeedback(
      String messType, String description, String messMeal) async {
    String? idToken = await widget.secureStorage.read(key: 'idToken');
    Map<String, dynamic> formMap = {
      'mess_type': messType,
      'feedback': description,
      'mess_meal': messMeal,
    };

    final requestUrl = Uri.parse(widget.baseUrl + '/mess/feedback');
    final response = await http.post(
      requestUrl,
      headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': 'idToken ' + idToken!
      },
      encoding: Encoding.getByName('utf-8'),
      body: formMap,
    );

    if (response.statusCode == 200) {
      return Future.value(true);
    }
    return Future.value(false);
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
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40.0),
                bottomRight: Radius.circular(0.0),
                topLeft: Radius.circular(40.0),
                bottomLeft: Radius.circular(0.0),
              ),
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
                        "Feedback",
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
                                width: 100,
                                child: DropdownButton<String>(
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                  value: _messValue,
                                  items: _messTypes.map((String items) {
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
                                width: 100,
                                child: DropdownButton<String>(
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                  value: _mealsValue,
                                  items: _messMeals.map((String items) {
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
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
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
                                      final res = await _submitFeedback(
                                        _messValue,
                                        _description.toString(),
                                        _mealsValue,
                                      );
                                      if (res) {
                                        await showFeedbackDialog(context,
                                            title: "Thank you",
                                            content:
                                                "We wil try to improve our service",
                                            defaultActionText: "Close");
                                        Navigator.of(context).pop();
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
