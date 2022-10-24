class StudentModel {
  final String firstName;
  final String lastName;
  final String email;
  const StudentModel({
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
    );
  }
}
