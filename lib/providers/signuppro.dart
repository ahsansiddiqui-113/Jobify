import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';

class SignUpPro with ChangeNotifier {
  double? latitude;
  double? longitude;
  File? dp;
  File? cv;
  String extension="";
  String otp = "";
  void generateOTP() {
    var rnd = Random();
    otp="";
    for (var i = 0; i < 5; i++) {
      otp += rnd.nextInt(10).toString();
    }
    // print("GENERATED OTP IS : : : : : : : : : : : : : : : : : : : : : : : : : : "+otp.toString());
  }

  notifyListenerz() {
    notifyListeners();
  }

  bool obscure1 = true;
  bool obscure2 = true;

  void clearAll() {
    dp=null;
    cv=null;
    obscure1 = true;
    obscure2 = true;
    latitude = longitude = null;
    notifyListeners();
  }
}
