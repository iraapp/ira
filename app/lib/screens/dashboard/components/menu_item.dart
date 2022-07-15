import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MenuItem extends StatelessWidget {
  IconData? iconData;
  String menuName;
  bool fade;
  VoidCallback pressHandler;

  MenuItem(
      {Key? key,
      this.iconData,
      this.menuName = '',
      required this.pressHandler,
      required this.fade})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
          child: IconButton(
            icon: Icon(
              iconData,
              color: Colors.white,
            ),
            iconSize: 65.0,
            onPressed: pressHandler,
          ),
          decoration: BoxDecoration(
            color: fade
                ? const Color.fromARGB(175, 58, 129, 253)
                : const Color(0xff3a82fd),
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
        Text(menuName),
      ],
    );
  }
}
