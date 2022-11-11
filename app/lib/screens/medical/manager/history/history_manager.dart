import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ira/screens/medical/manager/history/history_manager_detail.dart';
import 'package:ira/screens/medical/manager/history/student_model.dart';
import 'package:paginated_search_bar/paginated_search_bar.dart';

class HistoryManager extends StatefulWidget {
  const HistoryManager({Key? key}) : super(key: key);
  @override
  State<HistoryManager> createState() => _HistoryManagerState();
}

class _HistoryManagerState extends State<HistoryManager> {
  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];
  List<StudentModel> students = [];

  Future<List<StudentModel>> _getPatientData(String email) async {
    String? token = await secureStorage.read(key: 'staffToken');
    final requestUrl =
        Uri.parse(baseUrl + '/medical/search/patient?email=$email');

    final Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      'Authorization': token != null ? 'Token ' + token : '',
    };

    try {
      final response = await http.get(requestUrl, headers: headers);

      final responseData = json.decode(response.body);
      List<StudentModel> studentsData = [];
      responseData.forEach((student) {
        studentsData.add(StudentModel.fromJson(student));
      });

      if (response.statusCode == 200) {
        return studentsData;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: size.height * 0.05,
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
          SizedBox(
            height: size.height * 0.8,
            width: double.infinity,
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
                padding: const EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 30.0),
                child: Column(
                  children: [
                    PaginatedSearchBar<StudentModel>(
                      minSearchLength: 1,
                      hintText: "Search Student",
                      onSearch: ({
                        required pageIndex,
                        required pageSize,
                        required searchQuery,
                      }) async {
                        return _getPatientData(searchQuery);
                      },
                      itemBuilder: (
                        context, {
                        required item,
                        required index,
                      }) {
                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HistoryManagerDetail(
                                    student: item,
                                  ),
                                ),
                              );
                            },
                            child: Text(item.firstName + ' ' + item.lastName));
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
