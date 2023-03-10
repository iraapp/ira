import 'package:flutter/material.dart';
import 'package:ira/screens/mess/student/complains_mess_student.dart';
import 'package:ira/screens/mess/student/feedback_mess_student.dart';
import 'package:ira/screens/mess/student/menu/menu_mess_student.dart';
import 'package:ira/screens/mess/student/mom_mess_student.dart';
import 'package:ira/screens/mess/student/tender_mess_student.dart';
import 'package:ira/util/helpers.dart';

class MessStudentScreen extends StatefulWidget {
  const MessStudentScreen({Key? key}) : super(key: key);

  @override
  State<MessStudentScreen> createState() => _MessStudentScreenState();
}

class _MessStudentScreenState extends State<MessStudentScreen> {
  final List<DashboardIconModel> _messList = [
    DashboardIconModel(
      icon: const Icon(Icons.forum),
      title: "Feedback",
    ),
    DashboardIconModel(
      icon: const Icon(Icons.open_in_new),
      title: "Complaint",
    ),
    DashboardIconModel(
      icon: const Icon(Icons.ballot),
      title: "Menu",
    ),
    DashboardIconModel(icon: const Icon(Icons.drafts), title: "Mess MOM"),
    DashboardIconModel(icon: const Icon(Icons.content_paste), title: "Tenders"),
  ];

  final List<Widget> _messRoutes = [
    FeedbackMess(),
    ComplaintsMess(),
    const MessMenu(editable: false),
    MOMMess(),
    TenderMess(),
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
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text("Mess",
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
                    horizontal: 20.0, vertical: 40.0),
                child: GridView.builder(
                  itemCount: _messList.length,
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
                                builder: (context) => _messRoutes[index]));
                      },
                      child: Container(
                        width: 80.0,
                        height: 80.0,
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
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                child: _messList[index].icon,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                _messList[index].title,
                                style: const TextStyle(fontSize: 12.0),
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
