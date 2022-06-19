import 'mess_item.dart';

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
