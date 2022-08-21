import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/medical/doctor_details.dart/doctor_details.dart';
import 'package:ira/screens/medical/staff_contact/staff_contact.dart';

class MedicalStudentScreen extends StatefulWidget {
  const MedicalStudentScreen({Key? key}) : super(key: key);

  @override
  State<MedicalStudentScreen> createState() => _MedicalStudentScreenState();
}

class _MedicalStudentScreenState extends State<MedicalStudentScreen> {
  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  final List<String> _medicalList = ["Staff Contact", "Doctors"];

  final List<Widget> _medicalRoutes = [
    const StaffContactScreen(),
    const DoctorDetailsScreen(),
  ];

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
            height: size.height * 0.1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text("Medical",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.0,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.7,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 40.0,
                ),
                child: GridView.builder(
                  itemCount: _medicalList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => _medicalRoutes[index]));
                      },
                      child: Container(
                        width: 80.0,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ),
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 50.0,
                                  width: 50.0,
                                  child: Image.asset(
                                      "assets/images/mess_icon.png")),
                              const SizedBox(height: 5.0),
                              Text(_medicalList[index]),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
