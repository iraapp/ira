import 'package:flutter/material.dart';
import 'package:ira/screens/mess/student/menu/add_mess_item_modal_sheet.dart';
import 'package:ira/screens/mess/student/models/mess_menu_model.dart';

import 'edit_slot_time_modal_sheet.dart';
import 'mess_menu_item.dart';

double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

bool compareTime(TimeOfDay query) {
  return toDouble(TimeOfDay.fromDateTime(DateTime.now())) < toDouble(query);
}

class MenuPage extends StatelessWidget {
  final WeekDayModel weekDay;
  final bool currentDay;
  final bool editable;
  final VoidCallback updateView;

  const MenuPage({
    Key? key,
    required this.weekDay,
    required this.currentDay,
    required this.editable,
    required this.updateView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: weekDay.menus.length,
      itemBuilder: (context, index) {
        return ExpansionTile(
          initiallyExpanded: currentDay && !editable
              ? compareTime(weekDay.menus[index].slot.endTime)
              : true,
          textColor: Colors.black,
          iconColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                weekDay.menus[index].slot.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/icons/timer.png',
                    height: 14,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Text(
                    weekDay.menus[index].slot.startTime.format(context) +
                        ' - ' +
                        weekDay.menus[index].slot.endTime.format(context),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  editable
                      ? Row(children: [
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => EditSlotTimeAlertDialog(
                                  slotId: weekDay.menus[index].slot.id,
                                  startTime:
                                      weekDay.menus[index].slot.startTime,
                                  endTime: weekDay.menus[index].slot.endTime,
                                  successCallback: updateView,
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                            iconSize: 20,
                          ),
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => AddMessItemModalSheet(
                                  menuId: weekDay.menus[index].id,
                                  successCallback: updateView,
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_circle_outline),
                            iconSize: 20,
                          )
                        ])
                      : Container(),
                ],
              ),
            ],
          ),
          children: [
            for (var item in weekDay.menus[index].items)
              Column(
                children: [
                  MessMenuItem(
                    menuItem: item,
                    editable: editable,
                    updateView: updateView,
                  ),
                  Divider(
                    color: Colors.green.shade100,
                    indent: 20,
                    endIndent: 20,
                  )
                ],
              ),
          ],
        );
      },
    );
  }
}
