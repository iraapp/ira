class DoctorModel {
  DoctorModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.specialization,
    required this.mail,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.details,
  });
  final int id;
  final String name;
  final String phone;
  final String specialization;
  final String mail;
  final String date;
  final String startTime;
  final String endTime;
  final String details;

  factory DoctorModel.fromJson(Map<String, dynamic> json) => DoctorModel(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        specialization: json["specialization"],
        mail: json["mail"],
        date: json["date"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        details: json["details"],
      );
}
