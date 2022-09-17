import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ira/screens/mess/student/weekday_carousel_student.dart';

class MessMenu extends StatefulWidget {
  const MessMenu({Key? key}) : super(key: key);

  @override
  State<MessMenu> createState() => _MessMenuState();
}

class _MessMenuState extends State<MessMenu> {
  final List<Widget> _weekdaysCarousels = [
    WeekDayCarouselStudent(weekDay: "Monday"),
    WeekDayCarouselStudent(weekDay: "Tuesday"),
    WeekDayCarouselStudent(weekDay: "Wednesday"),
    WeekDayCarouselStudent(weekDay: "Thrusday"),
    WeekDayCarouselStudent(weekDay: "Friday"),
    WeekDayCarouselStudent(weekDay: "Saturday"),
    WeekDayCarouselStudent(weekDay: "Sunday"),
  ];
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
              topRight: Radius.circular(40.0),
              bottomRight: Radius.circular(0.0),
              topLeft: Radius.circular(40.0),
              bottomLeft: Radius.circular(0.0),
            ),
            color: Color(0xfff5f5f5),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
            child: Column(
              children: [
                Expanded(
                  child: CarouselSlider(
                    options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * 0.7),
                    items: _weekdaysCarousels,
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
