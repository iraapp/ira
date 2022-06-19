import 'package:flutter/material.dart';
import 'package:ira/screens/mess/components/mess_slot.dart';
import 'package:ira/screens/mess/factories/week_day.dart';

class MessWeekDay extends StatelessWidget {
  final WeekDay weekDay;

  const MessWeekDay({
    Key? key,
    required this.weekDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
              color: Color.fromARGB(255, 20, 12, 12),
              blurRadius: 5.0,
              offset: Offset(
                0,
                5,
              ))
        ],
      ),
      child: Column(children: [
        Text(
          weekDay.name,
          style: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        SizedBox(
          height: 450,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: weekDay.slots.length,
            itemBuilder: (BuildContext context, int index) {
              return MessSlot(slot: weekDay.slots[index]);
            },
          ),
        ),
      ]),
    );
  }
}
