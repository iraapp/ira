import 'package:flutter/material.dart';
import 'package:ira/screens/security_officer/gate_pass_data.dart';

securityOfficerMenu(context) {
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
                  builder: (context) => const GatePassData(),
                ),
              );
            },
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5.0),
        const Text(
          "Gate Pass Data",
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.white,
          ),
        ),
      ],
    ),
  ];
}
