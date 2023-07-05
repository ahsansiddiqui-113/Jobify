import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Api & Routes/routes.dart';
import '../Entities/jobobject.dart';

class ProfilePro with ChangeNotifier {
  List<JobObject> jobs = [];
  late String speciality;
  late List<String>skills=[];
  bool mainloading = false;
  bool showloading = true;
  int activepostindex = -1;
  bool isadmin=false;
  late int userid;
  late String name;
  late String email;
  late String pwd;
  late double lat;
  late double lng;
  bool profilepicupdated = false;
  late String dp;
  bool secondloading = false;
  int profileindex = 0;
  
  CLEARALL() {}
  notifyListenerz() {
    notifyListeners();
  }
}
