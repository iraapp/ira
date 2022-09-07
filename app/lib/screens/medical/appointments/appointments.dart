import 'package:flutter/material.dart';
import 'package:ira/screens/medical/appointments/appointment_card.dart';

class MedicalAppointmentsScreen extends StatefulWidget {
  const MedicalAppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<MedicalAppointmentsScreen> createState() =>
      _MedicalAppointmentsScreenState();
}

class _MedicalAppointmentsScreenState extends State<MedicalAppointmentsScreen> {
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
                      child: Text("Appointments",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.8,
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
                    horizontal: 30.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    children: [
                      AppointmentCard(
                          name: "Rahul Aggarwal",
                          details: "NA",
                          specialization: "Dentist",
                          contact: "9816092935",
                          email: "rahul.aggarwal@iitjammu.ac.in",
                          startTime: "11 AM",
                          endTime: "3 PM",
                          dateTime: "",
                          status: "In progress"),
                      AppointmentCard(
                        name: "Rahul Aggarwal",
                        details: "NA",
                        specialization: "Dentist",
                        contact: "9816092935",
                        email: "rahul.aggarwal@iitjammu.ac.in",
                        startTime: "11 AM",
                        endTime: "3 PM",
                        status: "Accepted",
                        dateTime: "2:30 PM  10 Sep",
                      ),
                      AppointmentCard(
                        name: "Rahul Aggarwal",
                        details: "NA",
                        specialization: "Dentist",
                        contact: "9816092935",
                        email: "rahul.aggarwal@iitjammu.ac.in",
                        startTime: "11 AM",
                        endTime: "3 PM",
                        status: "Rejected",
                        dateTime: '',
                      ),
                    ],
                  )
                  // child: FutureBuilder(
                  //   future: fetchDoctorDetails(),
                  //   builder:
                  //       (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting ||
                  //         snapshot.data == null) {
                  //       return const Center(child: CircularProgressIndicator());
                  //     }

                  //     return ListView.builder(
                  //         itemCount: snapshot.data['data'].length,
                  //         itemBuilder: (BuildContext context, int index) {
                  //           return DoctorCard(
                  //             name: snapshot.data['data'][index].name,
                  //             specialization:
                  //                 snapshot.data['data'][index].specialization,
                  //             contact: snapshot.data['data'][index].contact,
                  //             details: snapshot.data['data'][index].details,
                  //             email: snapshot.data['data'][index].mail,
                  //             startTime: snapshot.data['data'][index].startTime,
                  //             endTime: snapshot.data['data'][index].endTime,
                  //           );
                  //         });
                  //   },
                  // ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
