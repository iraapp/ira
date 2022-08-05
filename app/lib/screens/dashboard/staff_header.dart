import 'package:flutter/material.dart';
import 'package:ira/constants/constants.dart';
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

          if (localStorage.getItem('displayName') == null) {
            return const Text('');
          }

          String displayName = localStorage.getItem('staffName');

          String? displayRole =
              staffRoleDisplayNameMap[localStorage.getItem('staffRole')];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: const TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                displayRole!,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          );
        });
  }
}
