import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../Api & Routes/routes.dart';
import '../providers/bottomnavpro.dart';
import '../providers/homepro.dart';
import '../providers/uploadpostpro.dart';
import 'home.dart';
import 'profile.dart';

class BottomNavigation extends StatefulWidget {
  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  File? f;
  final tabs = [Home(), Profile()];
  @override
  Widget build(BuildContext context) {
    print("Bottom Navigation WIDGET REBUILTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
    
    return WillPopScope(
      onWillPop: () async {
        Provider.of<BottomNavigationPro>(context, listen: false).navindex = 0;
        Provider.of<BottomNavigationPro>(context, listen: false).notifyListenerz();
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: Container(
            // height: RouteManager.width / 6.5,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: BottomNavigationBar(
              backgroundColor: Provider.of<HomePro>(context).isdarkmode?Color.fromARGB(255, 223, 223, 223):Colors.white,
                items: [
                  BottomNavigationBarItem(
                    icon: Selector<BottomNavigationPro, Icon>(
                      selector: (p0, p1) => p1.homeicon,
                      builder: (context1, homeicon, child) {
                        return homeicon;
                      },
                    ),
                    label: "Home",
                    activeIcon: const Icon(Icons.home, color: Colors.blue),
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      // color: Colors.red,
                      // height: 50,
                      child: Column(
                        children: [
                          Icon(
                            Icons.photo_camera_rounded,
                            size: RouteManager.width / 15,
                            color: Colors.black,
                          ),
                          Text("Post", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: RouteManager.width / 26))
                        ],
                      ),
                    ),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Selector<BottomNavigationPro, Icon>(
                      selector: (p0, p1) => p1.profileicon,
                      builder: (context1, profileicon, child) {
                        return profileicon;
                      },
                    ),
                    label: "Profile",
                    activeIcon: const Icon(Icons.person, color: Colors.blue),
                  ),
                ],
                unselectedFontSize: RouteManager.width / 30,
                currentIndex: Provider.of<BottomNavigationPro>(context).navindex,
                fixedColor: Colors.blue,
                unselectedItemColor: Colors.blue,
                iconSize: RouteManager.width / 12,
                selectedFontSize: RouteManager.width / 26,
                unselectedIconTheme: const IconThemeData(opacity: 0.7),
                selectedIconTheme: const IconThemeData(opacity: 1),
                onTap: (value) {
                  if (value == 1) {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (contextssdsd) {
                          return AlertDialog(
                            elevation: 2000,
                            content: Row(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromRGBO(52, 109, 199, 10),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Camera ",
                                        style: TextStyle(fontSize: RouteManager.width / 22),
                                      ),
                                      Icon(Icons.camera_alt_rounded),
                                    ],
                                  ),
                                  onPressed: () async {
                                    final ImagePicker _picker = ImagePicker();
                                    final XFile? image = await _picker.pickImage(
                                      imageQuality: 10,
                                      source: ImageSource.camera,
                                    );
                                    Navigator.of(context).pop();
                                    if (image != null) {
                                      f = File(image.path);
                                      Provider.of<UploadPostPro>(context, listen: false).f = f;
                                      Navigator.of(context).pushNamed(
                                        RouteManager.uploadpost,
                                        // (route) => false,
                                      );
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: RouteManager.width / 20,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromRGBO(52, 109, 199, 10),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Gallery ",
                                        style: TextStyle(fontSize: RouteManager.width / 22),
                                      ),
                                      const Icon(Icons.photo_library),
                                    ],
                                  ),
                                  onPressed: () async {
                                    final ImagePicker _picker = ImagePicker();
                                    final XFile? image = await _picker.pickImage(
                                      imageQuality: 10,
                                      source: ImageSource.gallery,
                                    );
                                    Navigator.of(context).pop();
                                    if (image != null) {
                                      f = File(image.path);
                                      Provider.of<UploadPostPro>(context, listen: false).f = f;
                                      Navigator.of(context).pushNamed(
                                        RouteManager.uploadpost,
                                        // (route) => false,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  } else {
                    Provider.of<BottomNavigationPro>(context, listen: false).navindex = value;
                    Provider.of<BottomNavigationPro>(context, listen: false).notifyListenerz();
                  }
                }),
          ),
          body: Selector<BottomNavigationPro, int>(
            selector: (p0, p1) => p1.navindex,
            builder: (context, pindex, child) {
              if (pindex == 0) {
                return tabs[0];
              } else {
                return tabs[1];
              }
            },
          ),
        ),
      ),
    );
  }
}
