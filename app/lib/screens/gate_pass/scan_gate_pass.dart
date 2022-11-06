import 'package:flutter/material.dart';
import 'package:ira/screens/gate_pass/update_gate_pass.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanGatePass extends StatefulWidget {
  const ScanGatePass({Key? key}) : super(key: key);

  @override
  State<ScanGatePass> createState() => _ScanGatePassState();
}

class _ScanGatePassState extends State<ScanGatePass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
          allowDuplicates: false,
          onDetect: (barcode, args) {
            final String hash = barcode.rawValue!;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UpdateGatePass(hash: hash)));
          }),
    );
  }
}
