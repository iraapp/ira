class ComplaintModel {
  final String id;
  final String user;
  final String body;
  final String messMeal;
  final String messType;
  final String file;
  final String createdAt;
  final bool status;

  ComplaintModel({
    required this.id,
    required this.user,
    required this.body,
    required this.messMeal,
    required this.messType,
    required this.file,
    required this.createdAt,
    required this.status,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'].toString(),
      user: json['user']['first_name'] + ' ' + json['user']['last_name'],
      body: json['body'].toString(),
      messMeal: json['mess_meal'].toString(),
      messType: json["mess_type"] != null
          ? json["mess_type"]["name"].toString()
          : "NA",
      file: json['file'].toString(),
      createdAt: json['created_at'].toString(),
      status: json['status'],
    );
  }
}
