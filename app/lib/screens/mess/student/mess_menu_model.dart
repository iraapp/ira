// Weekday: Monday / Tuesday, etc
class WeekDay {
  final String weekday;
  final List<MealType> meals;

  WeekDay({
    required this.weekday,
    required this.meals,
  });

  factory WeekDay.fromJson(Map<String, dynamic> json) {
    return WeekDay(
      weekday: json['weekday'],
      meals: json['meals'],
    );
  }
}

// Meal Type: Breakfast / Lunch / Snacks / Dinner
class MealType {
  final String id;
  final MealSlot slot;
  final List<MealItems> items;

  MealType({
    required this.id,
    required this.slot,
    required this.items,
  });

  factory MealType.fromJson(Map<String, dynamic> json) {
    return MealType(
      id: json['id'].toString(),
      slot: MealSlot.fromJson(json['slot']),
      items: List<MealItems>.from(
        json['items'].map(
          (item) => MealItems.fromJson(item),
        ),
      ),
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
class MealItems {
  final String id;
  final String name;

  MealItems({
    required this.id,
    required this.name,
  });

  factory MealItems.fromJson(Map<String, dynamic> json) {
    return MealItems(
      id: json['id'].toString(),
      name: json['name'],
    );
  }
}
