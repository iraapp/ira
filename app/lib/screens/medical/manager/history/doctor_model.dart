class DoctorModel {
  DoctorModel(
    this.id,
    this.name,
    this.phone,
    this.specialization,
    this.mail,
    this.date,
    this.startTime,
    this.endTime,
    this.details,
  );
  final int id;
  final String name;
  final String phone;
  final String specialization;
  final String mail;
  final String date;
  final String startTime;
  final String endTime;
  final String details;

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      json['id'] as int,
      json['name'] as String,
      json['phone'] as String,
      json['specialization'] as String,
      json['mail'] as String,
      json['date'] as String,
      json['start_time'] as String,
      json['end_time'] as String,
      json['details'] as String,
    );
  }
}
