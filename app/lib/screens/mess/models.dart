class MessItem {
  String name;

  MessItem({required this.name});

  factory MessItem.fromJson(Map<String, dynamic> json) {
    return MessItem(name: json['name']);
  }
}

class Slot {
  String name;
  List<MessItem> items;

  Slot({
    required this.name,
    required this.items,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      items: (json['items'] as List)
          .map<MessItem>((json) => MessItem.fromJson(json))
          .toList(),
      name: json['name'],
    );
  }
}

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
