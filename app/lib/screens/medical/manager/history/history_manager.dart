import 'package:flutter/material.dart';

class HistoryManager extends StatefulWidget {
  const HistoryManager({Key? key}) : super(key: key);

  @override
  State<HistoryManager> createState() => _HistoryManagerState();
}

class _HistoryManagerState extends State<HistoryManager> {
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
          SizedBox(
            height: size.height * 0.05,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        "History Manager",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.8,
            child: Container(
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
                padding: const EdgeInsets.fromLTRB(30.0, 100.0, 30.0, 30.0),
                child: Form(
                  // key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 50.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Weight"),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                SizedBox(
                                  width: size.width * 0.5,
                                  child: TextFormField(
                                    //   controller: weightFieldController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please specify your weight';
                                      }

                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'kgs',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0.0, horizontal: 10.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Height"),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                SizedBox(
                                  width: size.width * 0.5,
                                  child: TextFormField(
                                    // controller: heightFieldController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please specify your height';
                                      }

                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'centimeters',
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 0.0,
                                        horizontal: 10.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text("Calculate"),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
