class MessItem {
  String name;

  MessItem({required this.name});

  factory MessItem.fromJson(Map<String, dynamic> json) {
    return MessItem(name: json['name']);
  }
}
