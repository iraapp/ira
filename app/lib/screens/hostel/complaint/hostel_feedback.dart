import 'package:flutter/material.dart';
import 'package:ira/screens/hostel/complaint/hostel_complaint.dart';

class HostelFeedback extends StatelessWidget {
  const HostelFeedback({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HostelComplaint(
      feedback: true,
    );
  }
}
