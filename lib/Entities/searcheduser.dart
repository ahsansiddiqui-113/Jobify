import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Api & Routes/routes.dart';

class SearchedUser with ChangeNotifier {
  // late int jobid;
  late int userid;
  late String name;
  late String dp;
  late double lat;
  late double lng;
  late double distance;
  late int jobs;
  SearchedUser(
    this.userid,
    this.name,
    this.dp,
    this.lat,
    this.lng,
    this.distance,
    this.jobs,
  );
  notifyListenerz() {
    notifyListeners();
  }
}
