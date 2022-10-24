import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class StaffHeader extends StatelessWidget {
  StaffHeader({Key? key}) : super(key: key);
  final localStorage = LocalStorage('store');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: localStorage.ready,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return const Text('');
          }

          if (localStorage.getItem('staffName') == null) {
            return const Text('');
          }

          String displayName = localStorage.getItem('staffName');

          return Text(
            displayName,
            style: const TextStyle(
              color: Colors.white,
            ),
          );
        });
  }
}
