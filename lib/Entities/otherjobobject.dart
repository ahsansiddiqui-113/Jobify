import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class OtherJobObject with ChangeNotifier {
  bool object=false;
  late int companyname;
  late int description;
  late String pic;
  String domain = "www.";
  OtherJobObject(
    this.companyname,
    this.description,
    this.pic,
    this.domain,
  );
  notifyListenerz() {
    notifyListeners();
  }
}
