import 'package:flutter/material.dart';

getHeightOf(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

String capitalize(String str) {
  return '${str[0].toUpperCase()}${str.substring(1).toLowerCase()}';
}

String formatDisplayName(String displayName) {
  return capitalize(displayName.split(' ')[0]) +
      ' ' +
      capitalize(displayName.split(' ')[1]);
}
