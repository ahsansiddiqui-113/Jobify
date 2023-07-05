import 'dart:io';
import 'package:flutter/cupertino.dart';
class UploadPostPro with ChangeNotifier {
  int totalskills=0;
  File? f;
  String? postcaption;
  notifyListenerz() {
    notifyListeners();
  }

  void clearAll() {
    totalskills=0;
    f=null;
    postcaption=null;
    notifyListeners();
  }
}
