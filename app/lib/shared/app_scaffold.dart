import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  const AppScaffold({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff3a82fd),
                  Color(0xff5077d3),
                  Color(0xff3c91c8),
                  Color(0xff72a8ee),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(60, 20),
                bottomRight: Radius.elliptical(60, 20),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: child,
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
