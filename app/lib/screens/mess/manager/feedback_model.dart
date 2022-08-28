class FeedbackModel {
  final String id;
  final String user;
  final String body;
  final String messType;
  final String messMeal;
  final String createdAt;
  final bool status;

  FeedbackModel({
    required this.id,
    required this.user,
    required this.body,
    required this.messType,
    required this.messMeal,
    required this.createdAt,
    required this.status,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'].toString(),
      user: json['user'].toString(),
      body: json['body'].toString(),
      messType: json['mess_type'].toString(),
      messMeal: json['mess_meal'].toString(),
      createdAt: json['created_at'].toString(),
      status: json['status'],
    );
  }
}
