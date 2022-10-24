import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MenuMessManager extends StatefulWidget {
  const MenuMessManager({Key? key}) : super(key: key);

  @override
  State<MenuMessManager> createState() => _MenuMessManagerState();
}

class _MenuMessManagerState extends State<MenuMessManager> {
  final List<Widget> _weekdaysCarousels = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text(
          "Menu",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          height: size.height -
              (MediaQuery.of(context).padding.top + kToolbarHeight),
        ),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(0.0),
              topLeft: Radius.circular(20.0),
              bottomLeft: Radius.circular(0.0),
            ),
            color: Color(0xfff5f5f5),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: Column(
              children: [
                Expanded(
                  child: CarouselSlider(
                      options: CarouselOptions(
                          height: MediaQuery.of(context).size.height * 0.7),
                      items: _weekdaysCarousels),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
