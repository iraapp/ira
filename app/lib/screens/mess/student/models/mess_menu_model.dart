import 'package:flutter/material.dart';

class WeekDayModel {
  final String weekday;
  final List<MessMenuModel> menus;

  WeekDayModel({
    required this.weekday,
    required this.menus,
  });

  factory WeekDayModel.fromJson(Map<String, dynamic> json) {
    List<MessMenuModel> menus = [];

    for (var k in json['menus'].keys) {
      menus.add(MessMenuModel.fromJson(json['menus'][k]));
    }

    return WeekDayModel(
      weekday: json['weekday'],
      menus: menus,
    );
  }
}

// Meal Type: Breakfast / Lunch / Snacks / Dinner
class MessMenuModel {
  final String id;
  final MealSlotModel slot;
  final List<MessMenuItemModel> items;

  MessMenuModel({
    required this.id,
    required this.slot,
    required this.items,
  });

  factory MessMenuModel.fromJson(Map<String, dynamic> json) {
    return MessMenuModel(
      id: json['id'].toString(),
      slot: MealSlotModel.fromJson(json['slot']),
      items: json['items']
          .map<MessMenuItemModel>((item) => MessMenuItemModel.fromJson(item))
          .toList(),
    );
  }
}

// Time Slots for Meal Type
class MealSlotModel {
  final String id;
  final String name;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  MealSlotModel({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
  });

  factory MealSlotModel.fromJson(Map<String, dynamic> json) {
    return MealSlotModel(
      id: json['id'].toString(),
      name: json['name'],
      startTime: TimeOfDay.fromDateTime(
          DateTime.parse('0000-00-00 ' + json['start_time'].toString() + 'Z')),
      endTime: TimeOfDay.fromDateTime(
          DateTime.parse('0000-00-00 ' + json['end_time'].toString() + 'Z')),
    );
  }
}

// Meal Items: Chicken / Rice / etc.
class MessMenuItemModel {
  final String id;
  final String name;
  final bool veg;
  final String description;
  final String imageUrl;

  MessMenuItemModel({
    required this.id,
    required this.name,
    required this.veg,
    required this.description,
    required this.imageUrl,
  });

  factory MessMenuItemModel.fromJson(Map<String, dynamic> json) {
    return MessMenuItemModel(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      imageUrl: json['image'],
      veg: json['veg'],
    );
  }
}
