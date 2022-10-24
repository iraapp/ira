import 'dart:math';

import 'package:flutter/material.dart';

class BMICalculator extends StatefulWidget {
  const BMICalculator({Key? key}) : super(key: key);

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController weightFieldController = TextEditingController();
  TextEditingController heightFieldController = TextEditingController();
  String result = "";

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
                        "BMI Calculator",
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
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        "Calculate",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
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
                                    controller: weightFieldController,
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
                                    controller: heightFieldController,
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
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    result = (int.parse(weightFieldController
                                                    .text) /
                                                pow(
                                                    int.parse(
                                                            heightFieldController
                                                                .text) /
                                                        100,
                                                    2))
                                            .toStringAsFixed(1) +
                                        " kg/m²";
                                  });
                                }
                              },
                              child: const Text("Calculate"),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              result,
                              style: const TextStyle(fontSize: 16.0),
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
