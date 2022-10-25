class WeekDay {
  final String weekday;
  final List<MessMenu> menus;

  WeekDay({
    required this.weekday,
    required this.menus,
  });

  factory WeekDay.fromJson(Map<String, dynamic> json) {
    List<MessMenu> menus = [];

    for (var k in json['menus'].keys) {
      menus.add(MessMenu.fromJson(json['menus'][k]));
    }
    return WeekDay(
      weekday: json['weekday'],
      menus: menus,
    );
  }
}

// Meal Type: Breakfast / Lunch / Snacks / Dinner
class MessMenu {
  final String id;
  final MealSlot slot;
  final List<MenuItem> items;

  MessMenu({
    required this.id,
    required this.slot,
    required this.items,
  });

  factory MessMenu.fromJson(Map<String, dynamic> json) {
    return MessMenu(
      id: json['id'].toString(),
      slot: MealSlot.fromJson(json['slot']),
      items: json['items']
          .map<MenuItem>((item) => MenuItem.fromJson(item))
          .toList(),
    );
  }
}

// Time Slots for Meal Type
class MealSlot {
  final String id;
  final String name;
  final String startTime;
  final String endTime;

  MealSlot({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
  });

  factory MealSlot.fromJson(Map<String, dynamic> json) {
    return MealSlot(
      id: json['id'].toString(),
      name: json['name'],
      startTime: json['start_time'].toString(),
      endTime: json['end_time'].toString(),
    );
  }
}

// Meal Items: Chicken / Rice / etc.
class MenuItem {
  final String id;
  final String name;

  MenuItem({
    required this.id,
    required this.name,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'].toString(),
      name: json['name'],
    );
  }
}
