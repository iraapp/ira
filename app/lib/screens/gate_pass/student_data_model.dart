class StudentDataModel {
  String name;
  String entryNo;
  String purpose;
  String contact;
  String? outTime;
  String? inTime;
  bool currentlyOut;

  StudentDataModel({
    required this.name,
    required this.entryNo,
    required this.purpose,
    required this.contact,
    required this.currentlyOut,
    required this.outTime,
    required this.inTime,
  });

  factory StudentDataModel.fromJson(dynamic json) {
    return StudentDataModel(
      name: json['user']['first_name'] + ' ' + json['user']['last_name'],
      entryNo: json['user']['email'].split('@')[0].toUpperCase(),
      purpose: json['purpose'],
      outTime: json['out_time_stamp'],
      inTime: json['in_time_stamp'],
      contact: json['contact'],
      currentlyOut: json['status'] == true && json['completed_status'] == false,
    );
  }
}
