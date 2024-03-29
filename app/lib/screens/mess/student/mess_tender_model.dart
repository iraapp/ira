class MessTenderModel {
  final String id;
  final String date;
  final String contractor;
  final String file;
  final String title;
  final String description;
  final String createdAt;
  final bool archived;

  MessTenderModel({
    required this.id,
    required this.date,
    required this.contractor,
    required this.file,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.archived,
  });

  factory MessTenderModel.fromJson(Map<String, dynamic> json) {
    return MessTenderModel(
      id: json['id'].toString(),
      date: json['date'].toString(),
      contractor: json['contractor'].toString(),
      file: json['file'].toString(),
      title: json['title'].toString(),
      description: json['description'].toString(),
      archived: json['archieved'],
      createdAt: json['createdAt'].toString(),
    );
  }
}
