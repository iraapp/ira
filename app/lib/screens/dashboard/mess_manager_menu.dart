import 'package:flutter/material.dart';
import 'package:ira/screens/mess/manager/mess_manager.dart';

messManagerMenu(context) {
  return [
    Column(children: [
      CircleAvatar(
        backgroundColor: const Color(0xFF09C7F9),
        child: IconButton(
          icon: const Icon(Icons.food_bank),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MessManagerScreen(),
              ),
            );
          },
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 5.0),
      const Text(
        "Mess",
        style: TextStyle(fontSize: 12.0),
      )
    ]),
  ];
}
