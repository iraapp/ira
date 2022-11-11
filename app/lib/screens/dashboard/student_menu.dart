import 'package:flutter/material.dart';
import 'package:ira/screens/dashboard/dashboard_icon.dart';
import 'package:ira/screens/gate_pass/purpose.dart';
import 'package:ira/screens/hostel/dashboard.dart';
import 'package:ira/screens/medical/dashboard.dart';
import 'package:ira/screens/mess/student/mess_student.dart';
import 'package:ira/screens/team/team.dart';
import '../hostel/secretary/hostel_secretary_screen.dart';

studentMenu(context, showHostelSecretary) {
  return [
    // DashboardIcon(
    //   icon: const Icon(Icons.person),
    //   title: "Id Card",
    //   pageRoute: Profile(),
    // ),
    DashboardIcon(
      icon: const Icon(Icons.apartment),
      title: "Hostel",
      pageRoute: const HostelStudentScreen(),
    ),

    DashboardIcon(
      icon: const Icon(Icons.fastfood),
      title: "Mess",
      pageRoute: const MessStudentScreen(),
    ),
    DashboardIcon(
      icon: const Icon(Icons.medical_services),
      title: "Medical",
      pageRoute: const MedicalStudentScreen(),
    ),
    DashboardIcon(
      icon: const Icon(Icons.sensor_door),
      title: "Gate Pass",
      pageRoute: const PurposeScreen(),
    ),
    DashboardIcon(
      icon: const Icon(Icons.groups),
      title: "Team",
      pageRoute: const TeamScreen(),
    ),

    showHostelSecretary
        ? DashboardIcon(
            icon: const Icon(Icons.add_moderator),
            title: "H. Secretary",
            pageRoute: const HostelSecretaryScreen(),
          )
        : Container(),
  ];
}
