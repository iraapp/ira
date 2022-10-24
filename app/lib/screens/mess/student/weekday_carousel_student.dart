import 'package:flutter/material.dart';
import 'package:ira/screens/mess/student/mess_menu_model.dart';

class WeekDayCarouselStudent extends StatelessWidget {
  final WeekDay weekDay;
  const WeekDayCarouselStudent({required this.weekDay, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  weekDay.weekday,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              SizedBox(
                height: 350.0,
                child: ListView.builder(
                  itemCount: weekDay.menus.length,
                  itemBuilder: ((context, index) {
                    return Column(
                      children: [
                        const Divider(),
                        Row(
                          children: [
                            Text(
                              weekDay.menus[index].slot.name,
                              style: const TextStyle(fontSize: 18.0),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              weekDay.menus[index].slot.startTime +
                                  ' ' +
                                  weekDay.menus[index].slot.endTime,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 100.0,
                          child: GridView.builder(
                              padding: const EdgeInsets.all(0),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 120.0,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 10,
                                childAspectRatio: 3,
                              ),
                              itemCount: weekDay.menus[index].items.length,
                              itemBuilder: (context, ind) => SizedBox(
                                    child: Chip(
                                        backgroundColor: Colors.white,
                                        label: Text(
                                          weekDay.menus[index].items[ind].name,
                                          style: const TextStyle(),
                                        )),
                                  )),
                        ),
                      ],
                    );
                  }),
                ),
              )
            ],
          ),
        ));
  }
}
