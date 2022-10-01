class DoctorModel {
  DoctorModel(
    this.id,
    this.name,
    this.phone,
    this.specialization,
    this.mail,
    this.date,
    this.start_time,
    this.end_time,
    this.details,
  );
  final int id;
  final String name;
  final String phone;
  final String specialization;
  final String mail;
  final String date;
  // ignore: non_constant_identifier_names
  final String start_time;
  // ignore: non_constant_identifier_names
  final String end_time;
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
