import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  IconData? iconData;
  String menuName;
  VoidCallback pressHandler;

  MenuItem(
      {Key? key, this.iconData, this.menuName = '', required this.pressHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
          child: IconButton(
            icon: Icon(
              iconData,
              color: Colors.white,
            ),
            iconSize: 65.0,
            onPressed: pressHandler,
          ),
          decoration: const BoxDecoration(
            color: Color(0xff3a82fd),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
        Text(menuName),
      ],
    );
  }
}
