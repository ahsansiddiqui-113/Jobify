import 'package:flutter/material.dart';

import '../Api & Routes/routes.dart';

class BottomNavigationPro with ChangeNotifier {
  int navindex = 0;
  // Icon homeicon = Icon(Icons.home_outlined, color: Colors.blue,size:RouteManager.width/11);
  // Icon profileicon = Icon(Icons.person_outline_outlined, color: Colors.blue,size:RouteManager.width/11);
  Icon homeicon = Icon(Icons.home_outlined, color: Colors.blue, size: RouteManager.width / 15);
  Icon profileicon = Icon(Icons.person_outline_outlined, color: Colors.blue, size: RouteManager.width / 15);
  int requestsbadge = 0;
  int notifsbadge = 0;
  int wishbadge = 0;
  notifyListenerz() {
    notifyListeners();
  }
}
