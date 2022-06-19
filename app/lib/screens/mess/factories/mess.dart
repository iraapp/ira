import 'week_day.dart';

class Mess {
  int id;
  String name;
  List<WeekDay> weekDays;

  Mess({
    required this.id,
    required this.name,
    required this.weekDays,
  });

  factory Mess.fromJson(Map<String, dynamic> json) {
    return Mess(
      id: json["id"],
      name: json["name"],
      weekDays: (json["week_days"] as List)
          .map<WeekDay>(
            (json) => WeekDay.fromJson(json),
          )
          .toList(),
    );
  }
}
