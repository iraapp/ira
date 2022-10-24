import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DashboardIcon extends StatelessWidget {
  Icon icon;
  String title;
  Widget pageRoute;

  DashboardIcon({
    Key? key,
    required this.icon,
    required this.title,
    required this.pageRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CircleAvatar(
        backgroundColor: Colors.blue.shade800,
        child: IconButton(
          icon: icon,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => pageRoute,
              ),
            );
          },
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 5.0),
      Text(
        title,
        style: const TextStyle(
          fontSize: 12.0,
          color: Colors.white,
        ),
      )
    ]);
  }
}
