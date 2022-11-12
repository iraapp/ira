import 'package:flutter/material.dart';

class GatePassData extends StatefulWidget {
  const GatePassData({Key? key}) : super(key: key);

  @override
  State<GatePassData> createState() => _GatePassDataState();
}

class _GatePassDataState extends State<GatePassData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gate Pass Data'),
        elevation: 0,
      ),
      body: const Center(
        child: Text('data'),
      ),
    );
  }
}
