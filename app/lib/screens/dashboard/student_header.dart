import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

String capitalize(String str) {
  return '${str[0].toUpperCase()}${str.substring(1).toLowerCase()}';
}

class StudentHeader extends StatelessWidget {
  StudentHeader({Key? key}) : super(key: key);
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

          String displayName = localStorage.getItem('displayName');

          return Text(
            capitalize(displayName.split(' ')[0]) +
                ' ' +
                capitalize(displayName.split(' ')[1]),
            style: const TextStyle(
              color: Colors.white,
            ),
          );
        });
  }
}
