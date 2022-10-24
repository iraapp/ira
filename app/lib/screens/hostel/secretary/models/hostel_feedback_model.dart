class HostelFeedbackModel {
  final String user;
  final String body;
  final String hostel;
  final String createdAt;

  HostelFeedbackModel({
    required this.user,
    required this.createdAt,
    required this.body,
    required this.hostel,
  });

  factory HostelFeedbackModel.fromJson(Map<String, dynamic> json) {
    return HostelFeedbackModel(
      createdAt: json['created_at'],
      user: json['user']['first_name'] + " " + json['user']['last_name'],
      body: json['body'],
      hostel: json['hostel']['name'],
    );
  }
}
