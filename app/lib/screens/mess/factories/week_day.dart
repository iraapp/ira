import 'slot.dart';

class WeekDay {
  String name;
  List<Slot> slots;

  WeekDay({
    required this.name,
    required this.slots,
  });

  factory WeekDay.fromJson(Map<String, dynamic> json) {
    return WeekDay(
      name: json['name'],
      slots: (json['slots'] as List)
          .map<Slot>((json) => Slot.fromJson(json))
          .toList(),
    );
  }
}
