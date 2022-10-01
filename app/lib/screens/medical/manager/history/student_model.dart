class StudentModel {
  final String firstName;
  final String lastName;
  final String email;
  const StudentModel(
    this.firstName,
    this.lastName,
    this.email,
  );

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      json['first_name'],
      json['last_name'],
      json['email'],
    );
  }
}
