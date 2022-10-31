import 'package:flutter/material.dart';
import 'package:ira/screens/dashboard/dashboard_icon.dart';
import 'package:ira/screens/gate_pass/purpose.dart';
import 'package:ira/screens/hostel/dashboard.dart';
import 'package:ira/screens/medical/dashboard.dart';
import 'package:ira/screens/mess/student/mess_student.dart';
import 'package:ira/screens/team/team.dart';
import '../hostel/secretary/hostel_secretary_screen.dart';
import '../profile/profile.dart';

studentMenu(context) {
  return [
    DashboardIcon(
      icon: const Icon(Icons.person),
      title: "Id Card",
      pageRoute: Profile(),
    ),
    DashboardIcon(
      icon: const Icon(Icons.food_bank),
      title: "Mess",
      pageRoute: const MessStudentScreen(),
    ),
    DashboardIcon(
      icon: const Icon(Icons.admin_panel_settings_rounded),
      title: "Gate Pass",
      pageRoute: PurposeScreen(),
    ),
    DashboardIcon(
      icon: const Icon(Icons.people),
      title: "Team",
      pageRoute: const TeamScreen(),
    ),
    DashboardIcon(
      icon: const Icon(Icons.person),
      title: "Hostel",
      pageRoute: const HostelStudentScreen(),
    ),
    DashboardIcon(
      icon: const Icon(Icons.person),
      title: "H. Secretary",
      pageRoute: const HostelSecretaryScreen(),
    ),
    DashboardIcon(
      icon: const Icon(Icons.medical_services),
      title: "Medical",
      pageRoute: const MedicalStudentScreen(),
    ),
  ];
}
