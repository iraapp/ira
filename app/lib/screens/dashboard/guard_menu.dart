import 'package:flutter/material.dart';
import 'package:ira/screens/gate_pass/scan_gate_pass.dart';

guardMenu(context) {
  return [
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue[800],
          child: IconButton(
            icon: const Icon(Icons.admin_panel_settings_rounded),
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
  ];
}
