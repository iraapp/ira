class MessTypesModel {
  const MessTypesModel({
    required this.id,
    required this.name,
  });
  final String id;
  final String name;

  factory MessTypesModel.fromJson(Map<String, dynamic> json) => MessTypesModel(
        id: json["id"].toString(),
        name: json["name"],
      );
}
