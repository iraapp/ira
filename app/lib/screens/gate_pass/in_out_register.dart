import 'package:flutter/material.dart';

class InOutRegister extends StatefulWidget {
  const InOutRegister({Key? key}) : super(key: key);

  @override
  State<InOutRegister> createState() => _InOutRegisterState();
}

class _InOutRegisterState extends State<InOutRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Container(),
    );
  }
}
