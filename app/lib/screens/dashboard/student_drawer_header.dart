import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:localstorage/localstorage.dart';

String capitalize(String str) {
  return '${str[0].toUpperCase()}${str.substring(1).toLowerCase()}';
}

class StudentDrawerHeader extends StatelessWidget {
  StudentDrawerHeader({Key? key}) : super(key: key);
  final localStorage = LocalStorage('store');
  final baseUrl = FlavorConfig.instance.variables['baseUrl'];

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
          String entry = localStorage.getItem('entry');

          return DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: Colors.blue.shade800,
                  child: CircleAvatar(
                    radius: 38,
                    child: ClipOval(
                        child: Image.network(
                            baseUrl + '/media/images/ashutosh.jpg')),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  capitalize(displayName.split(' ')[0]) +
                      ' ' +
                      capitalize(displayName.split(' ')[1]),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  entry.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
