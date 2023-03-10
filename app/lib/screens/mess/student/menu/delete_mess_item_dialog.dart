import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ira/screens/mess/student/models/mess_menu_model.dart';

// ignore: must_be_immutable
class DeleteMessItemDialog extends StatelessWidget {
  final MessMenuItemModel menuItem;
  final VoidCallback successCallback;

  DeleteMessItemDialog({
    Key? key,
    required this.menuItem,
    required this.successCallback,
  }) : super(key: key);

  final secureStorage = const FlutterSecureStorage();
  String baseUrl = FlavorConfig.instance.variables['baseUrl'];

  Future<bool> _deleteMessItem() async {
    final String? token = await secureStorage.read(key: 'staffToken');

    final response = await http.post(
        Uri.parse(baseUrl + '/mess/menu/item_delete'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': token != null ? 'Token ' + token : '',
        },
        body: {
          'menu_item_id': menuItem.id,
        });

    if (response.statusCode == 200) {
      return Future.value(true);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Are you sure, you want to delete this item?'),
        content: Text(menuItem.name),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              if (await _deleteMessItem()) {
                Navigator.of(context).pop();
                successCallback();

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Icon(
                      Icons.check,
                      size: 40,
                      color: Colors.green,
                    ),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Successfully Deleted'),
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'))
                    ],
                  ),
                );
              } else {
                Navigator.of(context).pop();

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Icon(
                      Icons.cancel,
                      size: 40,
                      color: Colors.red,
                    ),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Server Error. Failed to add.'),
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'))
                    ],
                  ),
                );
              }
            },
            child: const Text('Confirm Delete'),
          ),
        ]);
  }
}
