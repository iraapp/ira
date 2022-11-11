import 'package:flutter/material.dart';
import 'package:ira/screens/gate_pass/in_out_register.dart';
import 'package:ira/screens/gate_pass/scan_gate_pass.dart';

guardMenu(context) {
  return [
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue[800],
          child: IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScanGatePass(),
                ),
              );
            },
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5.0),
        const Text(
          "Scan QR",
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.white,
          ),
        ),
      ],
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue[800],
          child: IconButton(
            icon: const Icon(Icons.book),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InOutRegister(),
                ),
              );
            },
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5.0),
        const Text(
          "In Out Register",
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.white,
          ),
        ),
      ],
    ),
  ];
}
