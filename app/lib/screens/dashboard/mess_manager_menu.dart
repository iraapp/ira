import 'package:flutter/material.dart';
import 'package:ira/screens/mess/manager/complaints_mess_manager.dart';
import 'package:ira/screens/mess/manager/feedback_mess_manager.dart';
import 'package:ira/screens/mess/manager/menu_mess_manager.dart';
import 'package:ira/screens/mess/manager/mom_mess_manager.dart';
import 'package:ira/screens/mess/manager/tenders_mess_manager.dart';

messManagerMenu(context) {
  return [
    Column(children: [
      CircleAvatar(
        child: InkWell(
          child: SizedBox(
            height: 60.0,
            width: 60.0,
            child: Image.asset("assets/images/mess_icon.png"),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FeedbackMessManager(),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 5.0),
      const Text(
        "Feedbacks",
        style: TextStyle(fontSize: 12.0),
      )
    ]),
    Column(children: [
      CircleAvatar(
        child: InkWell(
          child: SizedBox(
            height: 60.0,
            width: 60.0,
            child: Image.asset("assets/images/mess_icon.png"),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ComplaintMessManager(),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 5.0),
      const Text(
        "Complaints",
        style: TextStyle(fontSize: 12.0),
      )
    ]),
    Column(children: [
      CircleAvatar(
        child: InkWell(
          child: SizedBox(
            height: 60.0,
            width: 60.0,
            child: Image.asset("assets/images/mess_icon.png"),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MenuMessManager(),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 5.0),
      const Text(
        "Menu",
        style: TextStyle(fontSize: 12.0),
      )
    ]),
    Column(children: [
      CircleAvatar(
        child: InkWell(
          child: SizedBox(
            height: 60.0,
            width: 60.0,
            child: Image.asset("assets/images/mess_icon.png"),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TendersMessManager(),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 5.0),
      const Text(
        "Tenders",
        style: TextStyle(fontSize: 12.0),
      )
    ]),
    Column(children: [
      CircleAvatar(
        child: InkWell(
          child: SizedBox(
            height: 60.0,
            width: 60.0,
            child: Image.asset("assets/images/mess_icon.png"),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MOMMessManager(),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 5.0),
      const Text(
        "MOM",
        style: TextStyle(fontSize: 12.0),
      )
    ]),
  ];
}
