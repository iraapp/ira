class MessMOMModel {
  final String id;
  final String date;
  final String file;
  final String title;
  final String description;
  final String createdAt;

  MessMOMModel({
    required this.id,
    required this.date,
    required this.file,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory MessMOMModel.fromJson(Map<String, dynamic> json) {
    return MessMOMModel(
      id: json['id'].toString(),
      date: json['date'].toString(),
      file: json['file'].toString(),
      title: json['title'].toString(),
      description: json['description'].toString(),
      createdAt: json['createdAt'].toString(),
    );
  }
}
