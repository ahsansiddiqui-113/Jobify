import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../Api & Routes/api.dart';
import '../Api & Routes/routes.dart';
import '../providers/bottomnavpro.dart';
// import '../providers/homepro.dart';
import '../providers/homepro.dart';
import '../providers/profilepro.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getMyPosts();
    });
  }

  getMyPosts() async {
    while (true) {
      Provider.of<ProfilePro>(context, listen: false).mainloading = !Provider.of<HomePro>(context, listen: false).mainloading;
      Provider.of<ProfilePro>(context, listen: false).showloading = true;
      Provider.of<ProfilePro>(context, listen: false).notifyListenerz();
      // if (Provider.of<HomePro>(context, listen: false).upperloading == false) {
      // Provider.of<HomePro>(context, listen: false).upperloading = false;
      print("GET FEED CALLEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
      var value = await API.getMyPosts(Provider.of<ProfilePro>(context, listen: false).userid, context);
      // then((value) {
      if (value) {
        Provider.of<ProfilePro>(context, listen: false).mainloading = !Provider.of<ProfilePro>(context, listen: false).mainloading;
        Provider.of<ProfilePro>(context, listen: false).showloading = false;
        // Provider.of<HomePro>(context, listen: false).upperloading = true;
        // Provider.of<HomePro>(context, listen: false).lowerloading=true;
        Provider.of<ProfilePro>(context, listen: false).notifyListenerz();
        // Navigator.of(context, rootNavigator: true).pop();
        return;
      }
      // });
      // }
      //   sleep(const Duration(seconds: 45));
    }
  }

  @override
  Widget build(BuildContext context) {
    print("SIGN IN WIDGET IS REBUILT");
    // RouteManager.width = MediaQuery.of(context).size.width;
    // RouteManager.height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Container(color: Color.fromARGB(255, 209, 209, 209)),
              Column(
                children: [
                  SizedBox(
                    height: RouteManager.width / 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Provider.of<HomePro>(context).isdarkmode ? Colors.grey : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(27.0),
                        topRight: Radius.circular(27.0),
                      ),
                    ),
                    alignment: const Alignment(-1, 0),
                    width: RouteManager.width,
                    height: RouteManager.height / 1.07,
                    child: Column(
                      children: [
                        SizedBox(
                          height: RouteManager.width / 2.6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: RouteManager.width / 30),
                            Text(
                              // "Ahsan",
                              Provider.of<ProfilePro>(context, listen: false).name,
                              style: TextStyle(fontSize: RouteManager.width / 20, color: Provider.of<HomePro>(context).isdarkmode ? Colors.white : Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // height: RouteManager.height / 1.471,
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: RouteManager.height / 18,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: RouteManager.width / 2.7,
                      ),
                      InkWell(
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: RouteManager.width / 7,
                          backgroundImage: NetworkImage(API.imageip + Provider.of<ProfilePro>(context).dp),
                        ),
                        onTap: () {
                          showDialog(
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
                                            API.showLoading("", context);
                                            await API.updateDp(Provider.of<ProfilePro>(context, listen: false).userid, File(image.path), context);
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
                                            API.showLoading("", context);
                                            await API.updateDp(Provider.of<ProfilePro>(context, listen: false).userid, File(image.path), context);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(height: RouteManager.width / 10),
                  Row(
                    children: [
                      SizedBox(
                        width: RouteManager.width / 1.23,
                      ),
                      
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  SizedBox(height: RouteManager.width / 1.95),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      Container(
                        // color: Colors.red,
                        child: Text(
                          Provider.of<ProfilePro>(context, listen: false).speciality,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: RouteManager.width / 15,
                            color: Provider.of<HomePro>(context).isdarkmode ? Colors.white : Colors.blue,
                          ),
                        ),
                       
                      )
                    ],
                  ),
                  SizedBox(
                    height: RouteManager.width / 20,
                  ),
                  Container(
                      width: RouteManager.width / 1.02,
                      height: RouteManager.height / 2,
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.blue)),
                        
                      ),
                      child: Selector<ProfilePro, bool>(
                          selector: (p0, p1) => p1.mainloading,
                          builder: (context, mainloading, child1) {
                            if (Provider.of<ProfilePro>(context).showloading) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (Provider.of<ProfilePro>(context).jobs.isEmpty) {
                              return Center(
                                  child: Text(
                                "No Jobs Posted",
                                style: TextStyle(fontSize: RouteManager.width / 15, color: Colors.blue),
                              ));
                            }
                            return ListView.builder(
                                itemCount: Provider.of<ProfilePro>(context).jobs.length,
                                itemBuilder: (cont, index) {
                                  return Column(
                                    children: [
                                      Container(
                                        width: RouteManager.width,
                                        child: Card(
                                          child: Stack(
                                            children: [
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: RouteManager.width / 1.2,
                                                      ),
                                                      IconButton(
                                                        iconSize: RouteManager.width / 14,
                                                        color: Colors.blue,
                                                        icon: Container(
                                                          width: RouteManager.width / 11,
                                                          height: RouteManager.width / 11,
                                                          // color: Colors.blue,
                                                          child: const Icon(
                                                            Icons.more_vert_rounded,
                                                            // color: Colors.white,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          showDialog(
                                                              context: context,
                                                              builder: (cont) {
                                                                return AlertDialog(
                                                                  content: Container(
                                                                      width: RouteManager.width / 20,
                                                                      height: RouteManager.width / 5,
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Center(
                                                                            child: InkWell(
                                                                              onTap: () async {
                                                                                API.showLoading("", context);
                                                                                API.deleteMyJob(Provider.of<ProfilePro>(context, listen: false).jobs[index].jobid).then((value) {
                                                                                  if (value) {
                                                                                    setState(() {
                                                                                      Provider.of<ProfilePro>(context, listen: false).jobs.removeAt(index);
                                                                                    });
                                                                                  }
                                                                                  Navigator.of(context, rootNavigator: true).pop();
                                                                                  Navigator.of(context, rootNavigator: true).pop();
                                                                                });
                                                                              },
                                                                              child: Text(
                                                                                "Delete",
                                                                                style: TextStyle(
                                                                                  color: Colors.red,
                                                                                  fontSize: RouteManager.width / 17,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height: RouteManager.width / 23,
                                                                          ),
                                                                          Container(
                                                                            width: RouteManager.width,
                                                                            color: const Color.fromARGB(255, 133, 133, 133),
                                                                            height: RouteManager.width / 900,
                                                                          ),
                                                                        ],
                                                                      )),
                                                                );
                                                              });
                                                        },
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  SizedBox(
                                                    height: RouteManager.width / 60,
                                                  ),
                                                  Expanded(
                                                    flex: 0,
                                                    child: Text(
                                                      // "dasdasdasdadasddsadasasdasddzzzaa",
                                                      Provider.of<ProfilePro>(context, listen: false).jobs[index].caption,

                                                      maxLines: 4,
                                                      style: TextStyle(
                                                        fontSize: RouteManager.width / 22,
                                                      ),
                                                      // overflow: TextOverflow.ellipsis,
                                                      textDirection: TextDirection.ltr,
                                                      textAlign: TextAlign.start,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: RouteManager.width / 70,
                                                  ),
                                                  Container(
                                                    width: RouteManager.width,
                                                    height: RouteManager.height / 2.5,
                                                    // color: Colors.green,
                                                    child: Stack(
                                                      // fit: StackFit.expand,
                                                      children: [
                                                        Container(
                                                          width: RouteManager.width,
                                                          // color:Colors.red,
                                                          height: RouteManager.height / 2.5,
                                                          child: Center(child: CircularProgressIndicator()),
                                                        ),
                                                        InkWell(
                                                          onTap: () {

                                                          },
                                                          child: Container(
                                                            child: Center(
                                                                child: Image.network(API.imageip +
                                                                    Provider.of<ProfilePro>(
                                                                      context,
                                                                    ).jobs[index].pic)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(width: RouteManager.width / 30),
                                                      Text(
                                                        "Skills:",
                                                        style: TextStyle(
                                                          fontSize: RouteManager.width / 20,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  // Container(
                                                  //   child:
                                                  Expanded(
                                                    flex: 0,
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      physics: const ClampingScrollPhysics(),
                                                      itemCount: Provider.of<ProfilePro>(context).jobs[index].skills.length,
                                                      itemBuilder: (cont, ind) {
                                                        return Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: RouteManager.width / 6,
                                                                ),
                                                                Icon(Icons.arrow_right, size: RouteManager.width / 14),
                                                                Text(Provider.of<ProfilePro>(context).jobs[index].skills[ind], style: TextStyle(fontSize: RouteManager.width / 25)),
                                                              ],
                                                            ),
                                                            SizedBox(height: RouteManager.width / 33),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                });
                          })),
                ],
              ),
            ],
          ),
          
        ),
      ),
    );
  }
}
