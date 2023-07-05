import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class JobObject with ChangeNotifier {
  bool object = true;
  late int jobid;
  late int userid;
  late String name;
  late String dp;
  late String caption;
  late String pic;
  List<String> skills = [];
  JobObject(
    this.userid,
    this.jobid,
    this.dp,
    this.name,
    this.caption,
    this.pic,
    this.skills,
    this.object,

  );

  late String companyname;
  late String description;
  late String title;

  JobObject.OtherObject(
    this.companyname,
    this.title,
    this.description,
    // this.logo,
    // this.domain,
    this.object,
  );

  notifyListenerz() {
    notifyListeners();
  }
}
