import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MessMenu extends StatefulWidget {
  const MessMenu({Key? key}) : super(key: key);

  @override
  State<MessMenu> createState() => _MessMenuState();
}

class _MessMenuState extends State<MessMenu> {
  final List<String> _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text(
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40.0),
              bottomRight: Radius.circular(0.0),
              topLeft: Radius.circular(40.0),
              bottomLeft: Radius.circular(0.0),
            ),
            color: const Color(0xfff5f5f5),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              children: [
                Expanded(
                  child: CarouselSlider(
                    options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * 0.7),
                    items: _weekdays.map((day) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        '$day',
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                    ),
                                    SizedBox(height: 80.0),
                                    Text(
                                      'Breakfast  (9:00 - 10:30)',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    SizedBox(height: 40.0),
                                    Text(
                                      'Lunch  (9:00 - 10:30)',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    SizedBox(height: 40.0),
                                    Text(
                                      'Snacks  (9:00 - 10:30)',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    SizedBox(height: 40.0),
                                    Text(
                                      'Dinner  (9:00 - 10:30)',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
