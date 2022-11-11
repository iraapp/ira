import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/hostel/secretary/hostel_complaints_management.dart';
import 'package:ira/screens/hostel/secretary/hostel_feedback_management.dart';
import 'package:ira/util/helpers.dart';

class HostelSecretaryScreen extends StatefulWidget {
  const HostelSecretaryScreen({Key? key}) : super(key: key);

  @override
  State<HostelSecretaryScreen> createState() => _HostelSecretaryScreenState();
}

class _HostelSecretaryScreenState extends State<HostelSecretaryScreen> {
  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  final List<DashboardIconModel> _hostelList = [
    DashboardIconModel(icon: const Icon(Icons.open_in_new), title: "Complaint"),
    DashboardIconModel(icon: const Icon(Icons.forum), title: "Feedback"),
  ];

  final List<Widget> _hostelRoutes = [
    ComplaintHostelSecretary(),
    HostelFeedbackManagement(),
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
                      child: Text("Hostel Secretary",
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
                color: Color(0xfff5f5f5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 40.0,
                ),
                child: GridView.builder(
                  itemCount: _hostelList.length,
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
                                builder: (context) => _hostelRoutes[index]));
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
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                child: _hostelList[index].icon,
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                _hostelList[index].title,
                                style: const TextStyle(fontSize: 12),
                              ),
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
