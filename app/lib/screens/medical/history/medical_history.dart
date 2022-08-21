import 'package:flutter/material.dart';
import 'package:ira/screens/medical/history/history_card.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({Key? key}) : super(key: key);

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
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
                      child: Text("History",
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
                  children: const [
                    HistoryCard(
                      date: '21 Aug 2022',
                      details: 'Cough and Fever',
                      diagnosis: 'Fever',
                      doctor: 'Dr Karunika Sharma',
                      inhouse: false,
                      treatment: 'Medication',
                    ),
                    HistoryCard(
                      date: '21 Aug 2022',
                      details: 'Cough and Fever',
                      diagnosis: 'Fever',
                      doctor: 'Dr Karunika Sharma',
                      inhouse: true,
                      treatment: 'Medication',
                    ),
                    HistoryCard(
                      date: '21 Aug 2022',
                      details: 'Cough and Fever',
                      diagnosis: 'Fever',
                      doctor: 'Dr Karunika Sharma',
                      inhouse: true,
                      treatment: 'Medication',
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
