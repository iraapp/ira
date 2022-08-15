class FeedbackModel {
  final String id;
  final String user;
  final String body;
  final String mess_type;
  final String created_at;
  final String status;

  FeedbackModel({
    required this.id,
    required this.user,
    required this.body,
    required this.mess_type,
    required this.created_at,
    required this.status,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'].toString(),
      user: json['user'].toString(),
      body: json['body'].toString(),
      mess_type: json['mess_type'].toString(),
      created_at: json['created_at'].toString(),
      status: json['status'].toString(),
    );
  }
}
