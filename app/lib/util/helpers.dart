import 'package:flutter/material.dart';

getHeightOf(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

String capitalize(String str) {
  return '${str[0].toUpperCase()}${str.substring(1).toLowerCase()}';
}

String formatDisplayName(String displayName) {
  return capitalize(displayName.split(' ')[0]) +
      ' ' +
      capitalize(displayName.split(' ')[1]);
}

List<String> rolesThatCanBeAssignedToStudent = [
  "student",
  "cultural_board",
  "technical_board",
  "sports_board",
  "hostel_board",
  "academic_board_ug",
  "academic_board_pg",
  "ira_team",
  "hostel_secretary"
];

bool isUserStudent(String role) {
  return rolesThatCanBeAssignedToStudent.contains(role);
}

List<String> rolesWithGoogleAuth = [
  "student",
  "swo_office",
  "academic_office_ug",
  "academic_office_pg",
  "gymkhana",
  "cultural_board",
  "technical_board",
  "sports_board",
  "hostel_board",
  "academic_board_ug",
  "academic_board_pg",
  "ira_team",
  "hostel_secretary"
];

bool isRoleWithGoogleAuth(String role) {
  return rolesWithGoogleAuth.contains(role);
}

List<String> rolesCanViewGeneralFeed = [
  "student",
  "swo_office",
  "academic_office_ug",
  "academic_office_pg",
  "gymkhana",
  "cultural_board",
  "technical_board",
  "sports_board",
  "hostel_board",
  "academic_board_ug",
  "academic_board_pg",
  "ira_team",
  "hostel_secretary"
];

List<String> rolesCanPostOnGeneralFeed = [
  "swo_office",
  "academic_office_ug",
  "academic_office_pg",
  "gymkhana",
  "cultural_board",
  "technical_board",
  "sports_board",
  "hostel_board",
  "academic_board_ug",
  "academic_board_pg",
  "ira_team",
  "hostel_secretary"
];

bool canShowGeneralFeed(String role) {
  return rolesCanViewGeneralFeed.contains(role);
}

bool canPostOnGeneralFeed(String role) {
  return rolesCanPostOnGeneralFeed.contains(role);
}

class DashboardIconModel {
  Icon icon;
  String title;

  DashboardIconModel({required this.icon, required this.title});
}
