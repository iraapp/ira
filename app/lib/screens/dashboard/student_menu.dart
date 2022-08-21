import 'package:flutter/material.dart';
import 'package:ira/screens/gate_pass/purpose.dart';
import 'package:ira/screens/hostel/dashboard.dart';
import 'package:ira/screens/medical/dashboard.dart';
import 'package:ira/screens/mess/student/mess_student.dart';
import 'package:ira/screens/team/team.dart';

import '../profile/profile.dart';

studentMenu(context) {
  return [
    Column(children: [
      CircleAvatar(
        backgroundColor: const Color(0xFF09C7F9),
        child: IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Profile(),
              ),
            );
          },
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 5.0),
      const Text(
        "Id Card",
        style: TextStyle(fontSize: 12.0),
      )
    ]),
    Column(children: [
      CircleAvatar(
        backgroundColor: const Color(0xFF09C7F9),
        child: IconButton(
          icon: const Icon(Icons.food_bank),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MessStudentScreen(),
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
    Column(children: [
      CircleAvatar(
        backgroundColor: const Color(0xFF09C7F9),
        child: IconButton(
          icon: const Icon(Icons.admin_panel_settings_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PurposeScreen(),
              ),
            );
          },
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 5.0),
      const Text(
        "Gate Pass",
        style: TextStyle(fontSize: 12.0),
      )
    ]),
    Column(children: [
      CircleAvatar(
        backgroundColor: const Color(0xFF09C7F9),
        child: IconButton(
          icon: const Icon(Icons.people),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TeamScreen(),
              ),
            );
          },
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 5.0),
      const Text(
        "Team",
        style: TextStyle(fontSize: 12.0),
      )
    ]),
    Column(children: [
      CircleAvatar(
        backgroundColor: const Color(0xFF09C7F9),
        child: IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HostelStudentScreen(),
              ),
            );
          },
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 5.0),
      const Text(
        "Hostel",
        style: TextStyle(fontSize: 12.0),
      )
    ]),
    Column(children: [
      CircleAvatar(
        backgroundColor: const Color(0xFF09C7F9),
        child: IconButton(
          icon: const Icon(Icons.medical_services),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MedicalStudentScreen(),
              ),
            );
          },
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 5.0),
      const Text(
        "Medical",
        style: TextStyle(fontSize: 12.0),
      )
    ]),
  ];
}
