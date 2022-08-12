class FeedbackModel {
  final String id;
  final String user;
  final String body;
  final String mess_no;
  final String created_at;
  final String status;

  FeedbackModel({
    required this.id,
    required this.user,
    required this.body,
    required this.mess_no,
    required this.created_at,
    required this.status,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'].toString(),
      user: json['user'] as String,
      body: json['body'] as String,
      mess_no: json['mess_no'].toString(),
      created_at: json['created_at'] as String,
      status: json['status'].toString(),
    );
  }
}
