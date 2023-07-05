import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Entities/jobobject.dart';
import '../Entities/searcheduser.dart';

class HomePro with ChangeNotifier {
  List<String> searches=["React","Flutter",".Net","React Native","Python","Clerk","Doctor","Driver","Database","Manager"];
  bool lowerloading=false;
  bool isdarkmode = false;
  List<SearchedUser> users = [];
  Set<Marker> markers = {};
  CameraPosition? initialcampos = null;
  int selecteddistance = 10;
  List<JobObject> jobs = [];
  bool mainloading = false;
  bool showloading = true;
  int page = 10;
  notifyListenerz() {
    notifyListeners();
  }

  void clearAll() {
    page=0;
    users = [];
    initialcampos = null;
    selecteddistance = 10;
    jobs = [];
    // upperloading = false;
    mainloading = false;
    showloading = true;
    // postsloaded = false;
    // posts = [];
    notifyListeners();
  }
}
