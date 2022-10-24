import 'dart:async';

import 'package:flutter/material.dart';

class PanelStateStream with ChangeNotifier {
  StreamController heightChangeController = StreamController.broadcast();
  bool state = false;

  Stream get stream => heightChangeController.stream;
}
