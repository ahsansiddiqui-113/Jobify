import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
// import 'package:image_editor/image_editor.dart';
import 'package:provider/provider.dart';
import '../Api & Routes/api.dart';
import '../Api & Routes/routes.dart';
import '../providers/homepro.dart';
import '../providers/profilepro.dart';
import '../providers/uploadpostpro.dart';
// import 'package:image_editor/image_editor.dart';
// import 'package:image_editor_plus/image_editor_plus.dart';

// class Signin extends StatefulWidget {
//   @override
//   State<Signin> createState() => _SigninState();
// }

class UploadPost extends StatefulWidget {
  @override
  State<UploadPost> createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost> {
  var teclist = [];

  @override
  void initState() {
    super.initState();
    // var _user = Provider.of<HomeProvider>(context).user;
  }

  TextEditingController cap = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<UploadPostPro>(context, listen: false).clearAll();
        // email.text = "";
        // pwd.text = "";
        // SystemNavigator.pop();
        // // Navigator.of(context).pop(true);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Provider.of<HomePro>(context).isdarkmode ? Colors.grey : Colors.blue,
            title: Text("Post Job", style: TextStyle(fontSize: RouteManager.width / 20)),
            actions: [
              TextButton(
                onPressed: () async {
                  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                  // Uint8List bytes = Provider.of<UploadPostPro>(context, listen: false).f!.readAsBytesSync();
                  // final editedImage = await Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => ImageCropper(
                  //       image: bytes, // <-- Uint8List of image
                  //     ),
                  //   ),
                  // );
                  // return;
                  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                  // var myeditorOption = ImageEditorOption();
                  // myeditorOption.addOption(FlipOption(horizontal: true, vertical: false));
                  // myeditorOption.addOption(RotateOption(180));
                  // await ImageEditor.editFileImageAndGetFile(file: Provider.of<UploadPostPro>(context, listen: false).f!, imageEditorOption: myeditorOption);
                  // setState(() {

                  // });
                  // print("Editing Doneeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
                  // return;
                  // final myeditorOption = ImageEditorOption();
                  // myeditorOption.addOption(FlipOption(horizontal: true, vertical: false));
                  // myeditorOption.addOption(RotateOption(180));
                  // ImageEditor.editFileImage(file: Provider.of<UploadPostPro>(context, listen: false).f!, imageEditorOption: myeditorOption);
                  // return;
                  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                  ///
                  ///
                  ///
                  ///
                  if (teclist.length == 0) {
                    ft.Fluttertoast.showToast(
                      msg: "Please provide atleast 1 skill",
                      toastLength: ft.Toast.LENGTH_LONG,
                    );
                    return;
                  }
                  String skills = "";
                  for (int i = 0; i < teclist.length; i++) {
                    if (teclist[i].text == "") {
                      ft.Fluttertoast.showToast(
                        msg: "Please fill all skills",
                        toastLength: ft.Toast.LENGTH_LONG,
                      );
                      return;
                    } else {
                      skills += teclist[i].text;
                      if (i != teclist.length - 1) {
                        skills += "`";
                      }
                    }
                  }
                  API.showLoading("Posting", context);
                  API
                      .addPost(
                    Provider.of<ProfilePro>(context, listen: false).userid,
                    skills,
                    cap.text,
                    // Provider.of<UploadPostPro>(context, listen: false).isprivate ? 1 : 0,
                    Provider.of<UploadPostPro>(context, listen: false).f!,
                    // context,
                  )
                      .then((value) async {
                    if (value) {
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
                          break;
                        }
                      }
                      Navigator.of(context, rootNavigator: true).pop();
                    }

                    Navigator.of(context, rootNavigator: true).pop();
                    if (value) {
                      Provider.of<UploadPostPro>(context, listen: false).clearAll();
                      Provider.of<UploadPostPro>(context, listen: false).notifyListenerz();
                      teclist = [];
                    }
                    // if (!Provider.of<HomePro>(context, listen: false).upperloading) {
                    // while (true) {
                    // print("RELOAD CALLEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDdd");
                    // Provider.of<HomePro>(context, listen: false).upperloading = true;
                    // Provider.of<HomePro>(context, listen: false).mainloading = !Provider.of<HomePro>(context, listen: false).mainloading;
                    // Provider.of<HomePro>(context, listen: false).showloading = true;
                    // Provider.of<HomePro>(context, listen: false).notifyListenerz();
                    // var value = await API.getFeed(Provider.of<ProfilePro>(context, listen: false).userid, 1, context);
                    // if (value) {
                    //   print("GET FEEEEEEEEEEEEEEDDDDDDDDDDDDDDD RESPONSSSSEEEEE RECEEEEEEEEEEEEEEEEVVVVVVVVVEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDdd");

                    //   Provider.of<HomePro>(context, listen: false).page = 2;
                    //   Provider.of<HomePro>(context, listen: false).mainloading = !Provider.of<HomePro>(context, listen: false).mainloading;
                    //   Provider.of<HomePro>(context, listen: false).showloading = false;
                    //   Provider.of<HomePro>(context, listen: false).upperloading = false;
                    //   Provider.of<HomePro>(context, listen: false).notifyListenerz();
                    //   Navigator.of(context, rootNavigator: true).pop();
                    //   Navigator.of(context, rootNavigator: true).pop();

                    //   Provider.of<UploadPostPro>(context, listen: false).clearAll();
                    //   setState(() {});
                    //   break;
                    // }
                    // }
                    // }
                  });
                },
                child: Container(
                  width: RouteManager.width / 7,
                  height: RouteManager.width / 13,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      "Post",
                      style: TextStyle(
                        // color: Colors.white,
                        fontSize: RouteManager.width / 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(width: RouteManager.width, height: RouteManager.width / 0.8, color: Colors.black, child: Image.file(Provider.of<UploadPostPro>(context).f!)),
                Container(
                  width: RouteManager.width,
                  height: RouteManager.width / 1.4,
                  // color: Colors.red,
                  child: Column(
                    children: [
                      SizedBox(
                        height: RouteManager.width / 23,
                      ),
                      TextField(
                        style: TextStyle(fontSize: RouteManager.width / 22),
                        decoration: const InputDecoration(
                          hintText: "Description of Job",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        controller: cap,
                      ),
                      // SizedBox(
                      //   height: RouteManager.width / 23,
                      // ),
                      // TextField(
                      //   enabled: false,
                      //   style: TextStyle(fontSize: RouteManager.width / 22),
                      //   decoration: InputDecoration(hintText: "Add Location"),
                      //   // controller: cap,
                      // ),
                      // SizedBox(
                      //   height: RouteManager.width / 10,
                      // ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Provider.of<HomePro>(context).isdarkmode ? Colors.grey : Colors.blue),
                        onPressed: () {
                          Provider.of<UploadPostPro>(context, listen: false).totalskills++;
                          teclist.add(TextEditingController());
                          Provider.of<UploadPostPro>(context, listen: false).notifyListenerz();
                        },
                        child: Text(
                          "Add Skill",
                          style: TextStyle(
                            fontSize: RouteManager.width / 30,
                          ),
                        ),
                      ),
                      Container(
                          // color: Colors.red,
                          height: RouteManager.width / 2.29,
                          child: ListView.builder(
                              itemCount: Provider.of<UploadPostPro>(context).totalskills,
                              itemBuilder: (cont, index) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: RouteManager.width / 40,
                                        ),
                                        Text((index + 1).toString() + ".    ", style: TextStyle(fontSize: RouteManager.width / 24, fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          width: RouteManager.width / 1.2,
                                          child: TextField(
                                            style: TextStyle(
                                              fontSize: RouteManager.width / 24,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "Enter Skill",
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: RouteManager.width / 24,
                                              ),
                                            ),
                                            controller: teclist[index],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              })),
                      // TextField(
                      //   // controller: TextEditingController(),
                      //   enabled: false,
                      //   style: TextStyle(fontSize: RouteManager.width / 22),

                      //   decoration: InputDecoration(suffixIcon: Icon(Icons.arrow_forward_ios_outlined, size: RouteManager.width / 18), hintText: "Tag People", hintStyle: TextStyle(color: Colors.black)),
                      //   // controller: cap,
                      // ),
                      // SizedBox(
                      //   height: RouteManager.width / 23,
                      // ),
                      // TextField(
                      //   // controller: TextEditingController(),
                      //   enabled: false,
                      //   style: TextStyle(fontSize: RouteManager.width / 22),

                      //   decoration:
                      //       InputDecoration(suffixIcon: Icon(Icons.arrow_forward_ios_outlined, size: RouteManager.width / 18), hintText: "Tag Products", hintStyle: TextStyle(color: Colors.black)),
                      //   // controller: cap,
                      // ),
                    ],
                  ),
                ),
                // Container(
                //   width: RouteManager.width,
                //   height: RouteManager.width / 7,
                //   color: Color.fromARGB(255, 226, 226, 226),
                //   child: Center(
                //       child: Container(
                //           width: RouteManager.width / 1.06,
                //           child: TextFormField(
                //             decoration: InputDecoration(
                //                 fillColor: Colors.white,
                //                 filled: true,
                //                 prefixIcon: Icon(
                //                   Icons.search,
                //                   size: RouteManager.width / 16,
                //                 ),
                //                 hintText: "Search"),
                //           ))),
                // ),
                // Column(
                //   children: [
                //     SizedBox(
                //       width: RouteManager.width,
                //       height: RouteManager.width / 6,
                //     ),
                //     Container(
                //       width: RouteManager.width,
                //       height: RouteManager.height / 1.365,
                //       // color: Colors.red,
                //     )
                //   ],
                // ),
                // Selector<HomePro, bool>(
                //   selector: (p0, p1) => p1.lowerloading,
                //   builder: (context, lowerloading, child1) {
                //     if (lowerloading) {
                //       return Column(
                //         children: [
                //           SizedBox(height: RouteManager.height / 1.32),
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Container(
                //                 width: RouteManager.width / 2.8,
                //                 height: RouteManager.width / 12,
                //                 decoration: BoxDecoration(
                //                   borderRadius: BorderRadius.all(Radius.circular(RouteManager.width / 23)),
                //                   border: Border.all(
                //                     color: Colors.blue,
                //                     style: BorderStyle.solid,
                //                   ),
                //                   color: Colors.blue,
                //                   // border: Border.all(color: Colors.blueAccent),
                //                 ),
                //                 child: Row(
                //                   children: [
                //                     SizedBox(
                //                       width: RouteManager.width / 26,
                //                     ),
                //                     SizedBox(
                //                         width: RouteManager.width / 18,
                //                         height: RouteManager.width / 18,
                //                         child: CircularProgressIndicator(
                //                           strokeWidth: RouteManager.width / 170,
                //                           color: Colors.white,
                //                         )),
                //                     Text("  Show More", style: TextStyle(color: Colors.white, fontSize: RouteManager.width / 28))
                //                   ],
                //                 ),
                //               ),
                //             ],
                //           )
                //         ],
                //       );
                //     }
                //     return SizedBox();
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
