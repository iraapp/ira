import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/medical/manager/history/doctor_model.dart';
import 'package:ira/screens/medical/manager/history/student_model.dart';
import 'package:paginated_search_bar/paginated_search_bar.dart';
import 'package:http/http.dart' as http;

class HistoryManagerDetail extends StatefulWidget {
  const HistoryManagerDetail({Key? key, required this.student})
      : super(key: key);
  final StudentModel student;

  @override
  State<HistoryManagerDetail> createState() => _HistoryManagerDetailState();
}

class _HistoryManagerDetailState extends State<HistoryManagerDetail> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController diagnosisFieldController = TextEditingController();
  TextEditingController treatmentFieldController = TextEditingController();
  TextEditingController detailsFieldController = TextEditingController();
  TextEditingController searchFieldController = TextEditingController();
  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];
  List<StudentModel> doctors = [];

  String selectedDoctor = '';
  int selectedDoctorId = 0;

  Future<List<DoctorModel>> _getDoctors(String name) async {
    String? token = await secureStorage.read(key: 'staffToken');
    final requestUrl = Uri.parse(
      baseUrl + '/medical/search/doctor?name=$name',
    );

    final Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      'Authorization': token != null ? 'Token ' + token : '',
    };

    try {
      final response = await http.get(requestUrl, headers: headers);

      final responseData = json.decode(response.body);
      final List<DoctorModel> doctorsData = [];
      responseData.forEach((doctor) {
        doctorsData.add(DoctorModel.fromJson(doctor));
      });

      if (response.statusCode == 200) {
        return doctorsData;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<bool> _submitHistoryManagerDetails({
    required String date,
    required String inhouse,
    required int doctorId,
    required String details,
    required String diagnosis,
    required String patient,
    required String treatment,
  }) async {
    final String? token = await secureStorage.read(key: 'staffToken');
    final requestUrl = Uri.parse(baseUrl + '/medical/medicalhistory/');

    Map<String, dynamic> formMap = {
      'date': date,
      'inhouse': inhouse,
      'doctor': doctorId.toString(),
      'patient': patient,
      'details': details,
      'diagnosis': diagnosis,
      'treatment': treatment,
    };

    final response = await http.post(
      requestUrl,
      headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': token != null ? 'Token ' + token : ''
      },
      encoding: Encoding.getByName('utf-8'),
      body: formMap,
    );

    if (response.statusCode == 200) {
      return Future.value(true);
    }

    // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
    return Future.value(false);
  }

  final List<String> _inhouseFill = ["Inhouse", "Outhouse"];
  String _inhouseFillValue = "Inhouse";
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: size.height * 0.04,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: Text(
                          "History Manager",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: size.height * 1.0,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40.0),
                    bottomRight: Radius.circular(0.0),
                    topLeft: Radius.circular(40.0),
                    bottomLeft: Radius.circular(0.0),
                  ),
                  color: Color(0xfff5f5f5),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          "Student Name",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          widget.student.firstName +
                              " " +
                              widget.student.lastName,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.5,
                          child: DropdownButton<String>(
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            value: _inhouseFillValue,
                            items: _inhouseFill.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(
                                  items,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _inhouseFillValue = value!;
                              });
                            },
                            borderRadius: BorderRadius.circular(10.0),
                            isExpanded: true,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Date"),
                                  GestureDetector(
                                    onTap: () async {
                                      await _selectDate(context);
                                    },
                                    child: Container(
                                      height: 40.0,
                                      width: size.width * 0.5,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(selectedDate
                                            .toLocal()
                                            .toString()
                                            .split(' ')[0]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Doctor Name"),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  SizedBox(
                                    width: size.width * 0.5,
                                    child: PaginatedSearchBar<DoctorModel>(
                                      inputController: searchFieldController,
                                      minSearchLength: 1,
                                      inputDecoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0.0,
                                                horizontal: 10.0),
                                        hintText: selectedDoctor == ""
                                            ? "Search Doctor"
                                            : selectedDoctor,
                                      ),
                                      onSearch: ({
                                        required pageIndex,
                                        required pageSize,
                                        required searchQuery,
                                      }) async {
                                        return _getDoctors(searchQuery);
                                      },
                                      itemBuilder: (
                                        context, {
                                        required item,
                                        required index,
                                      }) {
                                        return InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedDoctor = item.name;
                                                selectedDoctorId = item.id;
                                              });
                                              searchFieldController.clear();
                                            },
                                            child: Text(item.name));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Diagnosis"),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  SizedBox(
                                    width: size.width * 0.5,
                                    child: TextFormField(
                                      controller: diagnosisFieldController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please specify diagnosis';
                                        }

                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 10.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Treatment"),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  SizedBox(
                                    width: size.width * 0.5,
                                    child: TextFormField(
                                      controller: treatmentFieldController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please specify treatment';
                                        }

                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 0.0,
                                          horizontal: 10.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Details"),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  SizedBox(
                                    width: size.width * 0.5,
                                    child: TextFormField(
                                      controller: detailsFieldController,
                                      maxLines: 5,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please specify details';
                                        }

                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 0.0,
                                          horizontal: 10.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final String inhouse =
                                        _inhouseFillValue == "Inhouse"
                                            ? "True"
                                            : "False";

                                    final res =
                                        await _submitHistoryManagerDetails(
                                      date: selectedDate
                                          .toLocal()
                                          .toString()
                                          .split(' ')[0],
                                      inhouse: inhouse,
                                      doctorId: selectedDoctorId,
                                      patient: widget.student.email,
                                      details: detailsFieldController.text,
                                      diagnosis: diagnosisFieldController.text,
                                      treatment: treatmentFieldController.text,
                                    );

                                    if (res) {
                                      await showFeedbackDialog(context,
                                          title: "Submitted successfully",
                                          content:
                                              "Medical History submitted successfully",
                                          defaultActionText: "Close");
                                      Navigator.of(context).pop();
                                    }
                                  }
                                },
                                child: const Text("Add"),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future showFeedbackDialog(
    BuildContext context, {
    required String title,
    required String content,
    required String defaultActionText,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10.0),
            SizedBox(
                height: 100.0,
                child: Image.asset("assets/images/icon _tick circle.png")),
            const SizedBox(height: 20.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(content),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(defaultActionText),
          ),
        ],
      ),
    );
  }
}
