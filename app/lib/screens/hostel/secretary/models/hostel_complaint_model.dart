class HostelComplaintModel {
  final int id;
  final String user;
  final String body;
  final String hostel;
  final String createdAt;
  final bool status;
  final String file;
  final String complaintType;

  HostelComplaintModel({
    required this.id,
    required this.user,
    required this.createdAt,
    required this.body,
    required this.hostel,
    required this.status,
    required this.file,
    required this.complaintType,
  });

  factory HostelComplaintModel.fromJson(Map<String, dynamic> json) {
    return HostelComplaintModel(
      id: json['id'],
      createdAt: json['created_at'],
      user: json['user']['first_name'] + ' ' + json['user']['last_name'],
      body: json['body'],
      hostel: json['hostel']['name'],
      status: json['status'],
      complaintType: json['complaint_type']['name'],
      file: json['file'],
    );
  }
}
