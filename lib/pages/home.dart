import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../Api & Routes/api.dart';
import '../Api & Routes/routes.dart';
import '../providers/homepro.dart';
import '../providers/profilepro.dart';
import '../providers/uploadpostpro.dart';


class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late GoogleMapController _googleMapController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool mapcontrollerinit = false;
  final scrollcontroller = ScrollController();

  @override
  void dispose() {
    if (mapcontrollerinit) {
      _googleMapController.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    scrollcontroller.addListener(() {
      if (scrollcontroller.position.pixels == scrollcontroller.position.maxScrollExtent) {
        if (!Provider.of<HomePro>(context, listen: false).lowerloading && Provider.of<HomePro>(context, listen: false).page <= 100) {
          print("ShOW MORE CALLEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
          Provider.of<HomePro>(context, listen: false).lowerloading = true;
          Provider.of<HomePro>(context, listen: false).notifyListenerz();
          // Provider.of<HomePro>(context, listen: false).page = Provider.of<HomePro>(context, listen: false).page + 10;
          API.getSERPFeed(Provider.of<HomePro>(context, listen: false).page, context).then((value) {
            if (value) {
              Provider.of<HomePro>(context, listen: false).page++;
              Provider.of<HomePro>(context, listen: false).mainloading = !Provider.of<HomePro>(context, listen: false).mainloading;
              // Navigator.of(context, rootNavigator: true).pop();
            }
            Provider.of<HomePro>(context, listen: false).lowerloading = false;
            Provider.of<HomePro>(context, listen: false).notifyListenerz();
          });
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getMyFeed();
    });
  }

//paralel functions
  getMyFeed() async {
    while (true) {
      Provider.of<HomePro>(context, listen: false).mainloading = !Provider.of<HomePro>(context, listen: false).mainloading;
      Provider.of<HomePro>(context, listen: false).showloading = true;
      Provider.of<HomePro>(context, listen: false).notifyListenerz();

      print("GET FEED CALLEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
      var value = await API.getFeed(Provider.of<ProfilePro>(context, listen: false).userid, context);
      if (value) {
        Provider.of<HomePro>(context, listen: false).mainloading = !Provider.of<HomePro>(context, listen: false).mainloading;
        Provider.of<HomePro>(context, listen: false).showloading = false;
        Provider.of<HomePro>(context, listen: false).notifyListenerz();

        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    File? f;
    TextEditingController kmcontroller = TextEditingController();
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Provider.of<HomePro>(context, listen: false).clearAll();
          return true;
        },
        child: Scaffold(
          // backgroundColor: Colors.grey,
          key: _scaffoldKey,
          drawer: Drawer(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Color.fromARGB(255, 16, 19, 184),
                width: RouteManager.width / 150,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            width: RouteManager.width / 2.3,
            elevation: 3,
            child: Padding(
              padding: EdgeInsets.only(left: RouteManager.width / 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: RouteManager.width / 13,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        RouteManager.profilepage,
                        // (route) => false,
                      );
                    },
                    child: CircleAvatar(
                      radius: RouteManager.width / 8,
                      backgroundImage: NetworkImage(
                        API.imageip + Provider.of<ProfilePro>(context, listen: false).dp,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        RouteManager.profilepage,
                        // (route) => false,
                      );
                    },
                    child: Text(
                      // "  "+Provider.of,
                      "  " + Provider.of<ProfilePro>(context, listen: false).name,
                      style: TextStyle(
                        fontSize: RouteManager.width / 22,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: RouteManager.width / 4,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        RouteManager.changepwd,
                      );
                    },
                    child: Container(
                      width: RouteManager.width / 3,
                      padding: EdgeInsets.all(RouteManager.width / 50),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(
                          Radius.circular(RouteManager.width / 23),
                          // topRight:
                          // bottomLeft: Radius.circular(RouteManager.width / 23),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.person, color: Colors.white, size: RouteManager.width / 16),
                          Text(
                            " Password",
                            style: TextStyle(fontSize: RouteManager.width / 25, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: RouteManager.width / 2),
                  InkWell(
                    onTap: () {
                      Provider.of<ProfilePro>(context, listen: false).CLEARALL();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        RouteManager.signinpage,
                        (route) => false,
                      );
                      // Provider.of<BottomNavigationPro>(context, listen: false).navindex = 0;
                      // Provider.of<BottomNavigationPro>(context, listen: false).notifyListenerz();
                      Provider.of<HomePro>(context, listen: false).clearAll();
                    },
                    child: Container(
                      // width:RouteManager.width/2.7,
                      padding: EdgeInsets.all(RouteManager.width / 23),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 243, 75, 33),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(RouteManager.width / 23),
                          bottomRight: Radius.circular(RouteManager.width / 23),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Icon(Icons.logout_outlined, color: Colors.white, size: RouteManager.width / 14),
                          Text(
                            "     Log Out",
                            style: TextStyle(
                              fontSize: RouteManager.width / 19,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  width: RouteManager.width,
                  height: RouteManager.height / 1.24,
                  color: Provider.of<HomePro>(context).isdarkmode ? Color.fromARGB(255, 7, 7, 7) : Colors.white,
                ),
                Stack(
                  children: [
                    Container(
                      width: RouteManager.width,
                      height: RouteManager.width / 4,
                      // color: Color.fromARGB(255, 201, 18, 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  _scaffoldKey.currentState!.openDrawer();
                                },
                                child: Icon(
                                  Icons.menu,
                                  size: RouteManager.width / 12,
                                  color: Color.fromARGB(255, 56, 131, 192),
                                ),
                              ),
                              SizedBox(width: RouteManager.width / 1.30),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    RouteManager.profilepage,
                                    // (route) => false,
                                  );
                                },
                                child: Icon(
                                  Icons.person,
                                  size: RouteManager.width / 12,
                                  color: Color.fromARGB(255, 56, 131, 192),
                                ),
                              ),
                              SizedBox(width: RouteManager.width / 24),
                            ],
                          ),
                          Center(
                            child: Container(
                              width: RouteManager.width / 1.06,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Provider.of<HomePro>(context).isdarkmode ? Colors.grey : Colors.blue),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Search Jobs ", style: TextStyle(fontSize: RouteManager.width / 20)),
                                    Icon(
                                      Icons.location_on,
                                      size: RouteManager.width / 16,
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  print("AYAAa");
                                  showDialog(
                                    context: context,
                                    builder: (cont) {
                                      return AlertDialog(
                                        content: Container(
                                          width: RouteManager.width / 30,
                                          height: RouteManager.width / 1.71,
                                          padding: EdgeInsets.all(RouteManager.width / 20),
                                          child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: 10,
                                                      groupValue: Provider.of<HomePro>(context).selecteddistance,
                                                      onChanged: (int? value) {
                                                        setState(() {
                                                          Provider.of<HomePro>(context, listen: false).selecteddistance = value!;
                                                          Provider.of<HomePro>(context, listen: false).notifyListenerz();
                                                        });
                                                      },
                                                    ),
                                                    Text("10 Kms", style: TextStyle(fontSize: RouteManager.width / 23)),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: RouteManager.width / 23,
                                                ),
                                                Container(
                                                  width: RouteManager.width,
                                                  color: const Color.fromARGB(255, 133, 133, 133),
                                                  height: RouteManager.width / 900,
                                                ),
                                                SizedBox(
                                                  height: RouteManager.width / 23,
                                                ),
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: 50,
                                                      groupValue: Provider.of<HomePro>(context).selecteddistance,
                                                      onChanged: (int? value) {
                                                        setState(() {
                                                          Provider.of<HomePro>(context, listen: false).selecteddistance = value!;
                                                          // Provider.of<HomePro>(context,listen:false).notifyListenerz();
                                                        });
                                                      },
                                                    ),
                                                    Text("50 Kms", style: TextStyle(fontSize: RouteManager.width / 23))
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: RouteManager.width / 23,
                                                ),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Provider.of<HomePro>(context, listen: false).initialcampos = CameraPosition(
                                                          target: LatLng(Provider.of<ProfilePro>(context, listen: false).lat, Provider.of<ProfilePro>(context, listen: false).lng), zoom: 14);
                                                      API.showLoading("", context);
                                                      API
                                                          .searchJobs(
                                                        Provider.of<ProfilePro>(context, listen: false).userid,
                                                        Provider.of<ProfilePro>(context, listen: false).lat,
                                                        Provider.of<ProfilePro>(context, listen: false).lng,
                                                        Provider.of<HomePro>(context, listen: false).selecteddistance,
                                                        context,
                                                      )
                                                          .then((value) {
                                                        if (Provider.of<HomePro>(context, listen: false).users.isEmpty) {
                                                          ft.Fluttertoast.showToast(
                                                            msg: "No Jobs Found",
                                                            toastLength: ft.Toast.LENGTH_LONG,
                                                          );
                                                          Navigator.of(context, rootNavigator: true).pop();
                                                          return;
                                                        }
                                                        Navigator.of(context, rootNavigator: true).pop();
                                                        showDialog(
                                                            context: context,
                                                            builder: (cont) {
                                                              return SizedBox(
                                                                  width: RouteManager.width,
                                                                  height: RouteManager.height,
                                                                  child: Container(
                                                                      child: Stack(
                                                                    children: [
                                                                      StatefulBuilder(builder: (context, setState) {
                                                                        mapcontrollerinit = true;
                                                                        return GoogleMap(
                                                                          initialCameraPosition: Provider.of<HomePro>(context, listen: false).initialcampos!,
                                                                          mapType: MapType.hybrid,
                                                                          zoomControlsEnabled: true,
                                                                          onMapCreated: (controller) => _googleMapController = controller,
                                                                          markers: Provider.of<HomePro>(context, listen: false).markers,
                                                                        );
                                                                      }),
                                                                    ],
                                                                  )));
                                                            });
                                                      });
                                                    },
                                                    child: Text("Search", style: TextStyle(fontSize: RouteManager.width / 25)))
                                              
                                              ],
                                            );
                                          }),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      // width: RouteManager.width,
                      height: RouteManager.width / 4,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Provider.of<HomePro>(context).isdarkmode ? Colors.grey : Colors.blue),
                      child: SizedBox(
                        width: RouteManager.width / 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.filter_list,
                              size: RouteManager.width / 14,
                            ),
                            Text(
                              " Filter",
                              style: TextStyle(
                                fontSize: RouteManager.width / 23,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (cont) {
                            return AlertDialog(
                              content: Container(
                                width: RouteManager.width / 20,
                                height: RouteManager.width / 3.5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Enter Range in Km",
                                      style: TextStyle(fontSize: RouteManager.width / 25),
                                    ),
                                    TextFormField(
                                      controller: kmcontroller,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          hintText: "Kms...",
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                          )),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (kmcontroller.text == "") {
                                          ft.Fluttertoast.showToast(
                                            msg: "Field Empty",
                                            toastLength: ft.Toast.LENGTH_LONG,
                                          );
                                        }
                                        API.showLoading("", context);
                                        Provider.of<HomePro>(context, listen: false).showloading = true;
                                        Provider.of<HomePro>(context, listen: false).mainloading = !Provider.of<HomePro>(context, listen: false).mainloading;
                                        Provider.of<HomePro>(context, listen: false).notifyListenerz();
                                        while (true) {
                                          var value = await API.getFeedByDistance(
                                            Provider.of<ProfilePro>(context, listen: false).userid,
                                            Provider.of<ProfilePro>(context, listen: false).lat,
                                            Provider.of<ProfilePro>(context, listen: false).lng,
                                            double.parse(kmcontroller.text),
                                            context,
                                          );
                                          if (value) {
                                            Provider.of<HomePro>(context, listen: false).showloading = false;
                                            Provider.of<HomePro>(context, listen: false).mainloading = !Provider.of<HomePro>(context, listen: false).mainloading;
                                            Provider.of<HomePro>(context, listen: false).notifyListenerz();
                                            Navigator.of(context, rootNavigator: true).pop();
                                            Navigator.of(context, rootNavigator: true).pop();
                                            break;
                                          }
                                        }
                                      },
                                      child: Text("Filter", style: TextStyle(fontSize: RouteManager.width / 25)),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Container(color: Colors.grey, height: RouteManager.width / 200, width: RouteManager.width / 1.2),
                    Container(
                      width: RouteManager.width,
                      height: RouteManager.height / 1.265,
                      // color: Colors.red,
                      child: Selector<HomePro, bool>(
                        selector: (p0, p1) => p1.mainloading,
                        builder: (context, mainloading, child1) {
                          if (Provider.of<HomePro>(context).showloading) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (Provider.of<HomePro>(context).jobs.isEmpty) {
                            return Center(
                                child: Text(
                              "No Jobs Available 😔",
                              style: TextStyle(fontSize: RouteManager.width / 15, color: Colors.blue),
                            ));
                          }
                          return ListView.builder(
                            controller: scrollcontroller,
                            physics: const BouncingScrollPhysics(),
                            itemCount: Provider.of<HomePro>(context).jobs.length,
                            itemBuilder: (cont, index) {
                              if (!Provider.of<HomePro>(context).jobs[index].object) {
                                return Column(
                                  children: [
                                    Container(
                                      width: RouteManager.width,
                                      child: Card(
                                        color: Provider.of<HomePro>(context).isdarkmode ? Color.fromARGB(255, 184, 184, 184) : Color.fromARGB(255, 218, 241, 232),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: RouteManager.width / 60,
                                            ),
                                            Stack(
                                              children: [
                                                Center(
                                                  child: Text(
                                                    "  " + Provider.of<HomePro>(context, listen: false).jobs[index].companyname,
                                                    style: TextStyle(fontSize: RouteManager.width / 17, fontWeight: FontWeight.bold, color: Colors.blue),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: RouteManager.width / 60,
                                            ),
                                            Expanded(
                                              flex: 0,
                                              child: Text(
                                                "*" + Provider.of<HomePro>(context, listen: false).jobs[index].title + "*",
                                                // maxLines: 4,
                                                style: TextStyle(
                                                  fontSize: RouteManager.width / 22,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textDirection: TextDirection.ltr,
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                            SizedBox(
                                              height: RouteManager.width / 60,
                                            ),
                                            Expanded(
                                              flex: 0,
                                              child: Text(
                                                Provider.of<HomePro>(context, listen: false).jobs[index].description,
                                                // maxLines: 4,
                                                style: TextStyle(
                                                  fontSize: RouteManager.width / 22,
                                                ),
                                                textDirection: TextDirection.ltr,
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                            SizedBox(
                                              height: RouteManager.width / 70,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                API.showLoading("", context);
                                                print("EMAIL : " + Provider.of<ProfilePro>(context, listen: false).email);
                                                print("TITLE : " + Provider.of<HomePro>(context, listen: false).jobs[index].title);
                                                print("comp : " + Provider.of<HomePro>(context, listen: false).jobs[index].companyname);
                                                API
                                                    .sendEmail(
                                                  Provider.of<ProfilePro>(context, listen: false).name,
                                                  Provider.of<ProfilePro>(context, listen: false).email,
                                                  Provider.of<HomePro>(context, listen: false).jobs[index].title,
                                                  Provider.of<HomePro>(context, listen: false).jobs[index].companyname,
                                                  context,
                                                )
                                                    .then((value) {
                                                  Navigator.of(context, rootNavigator: true).pop();
                                                });
                                                // showDialog(
                                                //   context: context,
                                                //   builder: (abc) {
                                                //     return AlertDialog(elevation: 2000, content: Text("you have applied for this job"));
                                                //   },
                                                // );
                                              },
                                              child: Text(
                                                "Apply Now",
                                                style: TextStyle(fontSize: RouteManager.width / 20),
                                              ),
                                            ),
                                           
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: RouteManager.width / 15,
                                    ),
                                  ],
                                );
                              }
                              return Stack(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width: RouteManager.width,
                                        child: Card(
                                          color: Provider.of<HomePro>(context).isdarkmode ? const Color.fromARGB(255, 184, 184, 184) : Color.fromARGB(255, 218, 241, 232),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: RouteManager.width / 60,
                                              ),
                                              Stack(
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(width: RouteManager.width / 70),
                                                      CircleAvatar(
                                                        backgroundColor: Colors.black,
                                                        radius: RouteManager.width / 17,
                                                        foregroundImage: NetworkImage(API.imageip + Provider.of<HomePro>(context, listen: false).jobs[index].dp),
                                                      ),
                                                      Text(
                                                        "  " + Provider.of<HomePro>(context, listen: false).jobs[index].name,
                                                        style: TextStyle(fontSize: RouteManager.width / 25, fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: RouteManager.width / 60,
                                              ),
                                              Expanded(
                                                flex: 0,
                                                child: Text(
                                                  // "dasdasdasdadasddsadasasdasddzzzaa",
                                                  Provider.of<HomePro>(context, listen: false).jobs[index].caption,

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
                                                                Provider.of<HomePro>(
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
                                                  itemCount: Provider.of<HomePro>(context).jobs[index].skills.length,
                                                  itemBuilder: (cont, ind) {
                                                    return Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: RouteManager.width / 6,
                                                            ),
                                                            Icon(Icons.arrow_right, size: RouteManager.width / 14),
                                                            Text(Provider.of<HomePro>(context).jobs[index].skills[ind], style: TextStyle(fontSize: RouteManager.width / 25)),
                                                          ],
                                                        ),
                                                        SizedBox(height: RouteManager.width / 33),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                              Provider.of<HomePro>(context).jobs[index].userid != Provider.of<ProfilePro>(context).userid && !Provider.of<ProfilePro>(context).isadmin
                                                  ? ElevatedButton(
                                                      onPressed: () {
                                                        API.showLoading("", context);
                                                        API
                                                            .sendEmail(
                                                          Provider.of<ProfilePro>(context, listen: false).name,
                                                          Provider.of<ProfilePro>(context, listen: false).email,
                                                          "Job",
                                                          Provider.of<HomePro>(context, listen: false).jobs[index].companyname,
                                                          context,
                                                        )
                                                            .then((value) {
                                                          Navigator.of(context, rootNavigator: true).pop();
                                                        });
                                                        
                                                      },
                                                      child: Text(
                                                        "Apply Now",
                                                        style: TextStyle(fontSize: RouteManager.width / 20),
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: RouteManager.height / 40,
                                      ),
                                    ],
                                  ),
                                  Provider.of<ProfilePro>(context).isadmin
                                      ? Column(
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(width: RouteManager.width / 1.18),
                                                IconButton(
                                                  iconSize: RouteManager.width / 10,
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
                                                                          API.deleteMyJob(Provider.of<HomePro>(context, listen: false).jobs[index].jobid).then((value) {
                                                                            if (value) {
                                                                              setState(() {
                                                                                Provider.of<HomePro>(context, listen: false).jobs.removeAt(index);
                                                                                // Provider.of<ProfilePro>(context, listen: false).jobs.removeAt(index);
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
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                      : SizedBox(),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),

          floatingActionButton: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment:MainAxisAlignment.center,
            children: [
              SizedBox(width: RouteManager.width / 2.270),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: RouteManager.width / 100,
                  shape: CircleBorder(),
                  // foregroundColor: Colors.red,
                  // side: BorderSide(color: Colors.red),
                  backgroundColor: Color.fromARGB(255, 188, 225, 255),
                ),
                onPressed: () /*async*/ {
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
                },
                child: Padding(
                  padding: EdgeInsets.all(RouteManager.width / 40),
                  child: Icon(
                    Icons.photo_camera_rounded,
                    size: RouteManager.width / 15,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}