import 'package:flutter/material.dart';
import 'package:ira/screens/mess/student/menu/menu_mess_student.dart';

class MenuMessManager extends StatefulWidget {
  const MenuMessManager({Key? key}) : super(key: key);

  @override
  State<MenuMessManager> createState() => _MenuMessManagerState();
}

class _MenuMessManagerState extends State<MenuMessManager> {
  @override
  Widget build(BuildContext context) {
    return const MessMenu(editable: true);
  }
}
