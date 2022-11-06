import 'package:flutter/material.dart';

import '../medical/manager/medical_manager.dart';

medicalManagerMenu(context) {
  return [
    Column(children: [
      CircleAvatar(
        backgroundColor: Colors.blue[800],
        child: IconButton(
          icon: const Icon(Icons.food_bank),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MedicalManagerScreen(),
              ),
            );
          },
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 5.0),
      const Text(
        "Medical",
        style: TextStyle(
          fontSize: 12.0,
          color: Colors.white,
        ),
      )
    ]),
  ];
}
