import 'package:flutter/material.dart';

class ComplaintMessManager extends StatefulWidget {
  const ComplaintMessManager({Key? key}) : super(key: key);

  @override
  State<ComplaintMessManager> createState() => _ComplaintMessManagerState();
}

class _ComplaintMessManagerState extends State<ComplaintMessManager> {
  bool _actionTaken = false;
  final List<String> _filter = ["Filter", "Date", "Mess", "Action"];
  String _filterValue = "Filter";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text(
          "Complaints",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: ConstrainedBox(
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
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: 100,
                    child: DropdownButton<String>(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      value: _filterValue,
                      items: _filter.map((String items) {
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
                          _filterValue = value!;
                        });
                      },
                      borderRadius: BorderRadius.circular(10.0),
                      isExpanded: true,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          await showComplaintDialog(context,
                              title: "Pratham",
                              subtitle: "1B Mess | Breakfast | 06-07-2022",
                              content: "jkwheqk " * 30,
                              defaultActionText: "Close");
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children: [
                              Container(
                                  height: size.height * 0.25,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0),
                                        topLeft: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0.0, 1.0), //(x,y)
                                          blurRadius: 1.0,
                                        ),
                                      ],
                                      color: Colors.white),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(10.0),
                                            bottomRight: Radius.circular(0.0),
                                            topLeft: Radius.circular(10.0),
                                            bottomLeft: Radius.circular(0.0),
                                          ),
                                          color: !_actionTaken
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text("Pratham",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      )),
                                                  !_actionTaken
                                                      ? SizedBox(
                                                          height: 30.0,
                                                          child: ElevatedButton(
                                                            onPressed: null,
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(
                                                                Colors.white,
                                                              ),
                                                              shape: MaterialStateProperty
                                                                  .all<
                                                                      RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15.0),
                                                                ),
                                                              ),
                                                            ),
                                                            child: const Text(
                                                                "Take Action",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      12.0,
                                                                )),
                                                          ),
                                                        )
                                                      : SizedBox(
                                                          height: 30.0,
                                                          child: ElevatedButton(
                                                            onPressed: () {},
                                                            child: const Icon(
                                                              Icons.done,
                                                              color:
                                                                  Colors.green,
                                                              size: 18.0,
                                                            ),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              primary:
                                                                  Colors.white,
                                                              shape:
                                                                  const CircleBorder(),
                                                            ),
                                                          ),
                                                        ),
                                                ],
                                              ),
                                              Builder(builder: (context) {
                                                return const Text(
                                                    "1B Mess | Breakfast | 06-07-2022",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ));
                                              }),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Wrap(
                                          children: [
                                            Text("jkwheqk " * 30,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future showComplaintDialog(
    BuildContext context, {
    required String title,
    required String subtitle,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16.0)),
                    const SizedBox(height: 10.0),
                    Text(subtitle, style: const TextStyle(fontSize: 14.0)),
                    const SizedBox(height: 10.0),
                  ],
                ),
                SizedBox(
                    height: 40.0,
                    child: Image.asset("assets/images/phone_icon.png")),
              ],
            ),
            const SizedBox(height: 10.0),
            Container(
                color: const Color(0xfff5f5f5),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(content, style: const TextStyle(fontSize: 14.0)),
                )),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Details", style: TextStyle(fontSize: 14.0)),
              ],
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              height: 40.0,
              child: ElevatedButton(
                onPressed: () {
                  if (!_actionTaken) {
                    setState(() {
                      _actionTaken = !_actionTaken;
                      Navigator.pop(context);
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    !_actionTaken ? Colors.red : Colors.green,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: Text(!_actionTaken ? "Take Action" : "Action Taken",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    )),
              ),
            )
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
}
