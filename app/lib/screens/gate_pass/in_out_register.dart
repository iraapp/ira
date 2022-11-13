import 'package:flutter/material.dart';

import 'all_tab.dart';
import 'out_tab.dart';

class InOutRegister extends StatefulWidget {
  const InOutRegister({Key? key}) : super(key: key);

  @override
  State<InOutRegister> createState() => _InOutRegisterState();
}

class _InOutRegisterState extends State<InOutRegister> {
  bool _isActive = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text(
          "Register",
        ),
        elevation: 0,
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          height: size.height -
              (MediaQuery.of(context).padding.top + kToolbarHeight),
        ),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xfff5f5f5),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isActive = true;
                          });
                        },
                        child: Text("Out",
                            style: TextStyle(
                              decoration:
                                  _isActive ? TextDecoration.underline : null,
                              color: _isActive ? Colors.blue : Colors.black,
                              fontSize: 16,
                            )),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isActive = false;
                          });
                        },
                        child: Text("All",
                            style: TextStyle(
                              fontSize: 16,
                              color: !_isActive ? Colors.blue : Colors.black,
                              decoration:
                                  !_isActive ? TextDecoration.underline : null,
                            )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 500,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: _isActive ? const OutTab() : const AllTab(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
