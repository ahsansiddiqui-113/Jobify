import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../Api & Routes/api.dart';
import '../Api & Routes/routes.dart';
import '../providers/signuppro.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
import 'package:file_picker/file_picker.dart';
// class Signin extends StatefulWidget {
//   @override
//   State<Signin> createState() => _SigninState();
// }

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formkey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();

  // TextEditingController otp = TextEditingController();

  // TextEditingController username = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController pwd2 = TextEditingController();

  TextEditingController pwd = TextEditingController();

  TextEditingController speciality = TextEditingController();

  // File? dp;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDialog('Fetching Location');
      _determinePosition().then((value) {
        Provider.of<SignUpPro>(context, listen: false).latitude = double.parse(value.split('|')[0]);
        Provider.of<SignUpPro>(context, listen: false).longitude = double.parse(value.split('|')[1]);
        Navigator.of(context, rootNavigator: true).pop();
      });
    });
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    print("SIGN UP WIDGET IS REBUILT");
    RouteManager.width = MediaQuery.of(context).size.width;
    RouteManager.height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        Provider.of<SignUpPro>(context, listen: false).clearAll();
        email.text = "";
        pwd.text = "";
        Navigator.of(context).pop(true);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            // reverse: true,
            child: Stack(
              children: [
                // Container(
                //   height: RouteManager.height,
                //   width: RouteManager.width,
                //   child: Image.asset("assets/images/newbackground.jpg", fit: BoxFit.fill),
                // ),
                Column(
                  children: [
                    SizedBox(
                      height: RouteManager.width / 20,
                      width: RouteManager.width,
                    ),
                    InkWell(
                      child: Container(
                        height: RouteManager.width / 4,
                        width: RouteManager.width / 3.6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        // child: Column(
                        //   children: [
                        //     SizedBox(
                        //       height: RouteManager.width / 22,
                        //     ),
                        //     Text("Add",
                        //         style: TextStyle(
                        //           fontSize: RouteManager.width / 18,
                        //         )),
                        //     Text("Photo",
                        //         style: TextStyle(
                        //           fontSize: RouteManager.width / 18,
                        //         )),
                        //   ],
                        // ),
                        child: Provider.of<SignUpPro>(context).dp != null
                            ? CircleAvatar(
                                // radius: RouteManager.width /2000,
                                backgroundImage: Image.file(
                                  Provider.of<SignUpPro>(context, listen: false).dp!,
                                  fit: BoxFit.contain,
                                  // frameBuilder: (context, child, frame, loaded,) {
                                  //   if(!loaded)
                                  //   {
                                  //     return Text("OOadsja da dasd sadkjsahd sajd ");
                                  //   }
                                  //   if (frame == null) {
                                  //     return const SizedBox(
                                  //         child: Center(
                                  //       child: CircularProgressIndicator(
                                  //         color: Colors.red,
                                  //       ),
                                  //     ));
                                  //   }
                                  //   else
                                  //   {
                                  //     return Text("OKKKKKKKKKKKKK");
                                  //   }
                                  //   return child;
                                  // },
                                ).image,
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: RouteManager.width / 22,
                                  ),
                                  Text("Add",
                                      style: TextStyle(
                                        fontSize: RouteManager.width / 18,
                                      )),
                                  Text("Photo",
                                      style: TextStyle(
                                        fontSize: RouteManager.width / 18,
                                      )),
                                ],
                              ),
                      ),
                      onTap: () {
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
                                          Provider.of<SignUpPro>(context, listen: false).dp = File(image.path);
                                          // Provider.of<AddItemPro>(context, listen: false).showbox = true;
                                          // if (Provider.of<AddItemPro>(context, listen: false).images.length == 5) {
                                          //   Provider.of<AddItemPro>(context, listen: false).maxreached = true;
                                          // }
                                          Provider.of<SignUpPro>(context, listen: false).notifyListenerz();
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
                                          Provider.of<SignUpPro>(context, listen: false).dp = File(image.path);
                                          // Provider.of<AddItemPro>(context, listen: false).showbox = true;
                                          // if (Provider.of<AddItemPro>(context, listen: false).images.length == 5) {
                                          //   Provider.of<AddItemPro>(context, listen: false).maxreached = true;
                                          // }
                                          Provider.of<SignUpPro>(context, listen: false).notifyListenerz();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                    // Row(
                    //   children: [
                    //     SizedBox(
                    //       width: RouteManager.width / 3.2,
                    //     ),
                    //     Container(
                    //       width: RouteManager.width / 2.6,
                    //       height: RouteManager.height / 5,
                    //       child: Image.asset("assets/images/logofootshoot.png", fit: BoxFit.fill),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(
                      height: RouteManager.height / 60,
                    ),
                    Form(
                      key: formkey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: RouteManager.width / 13,
                                  ),
                                  Opacity(
                                    opacity: 0.4,
                                    child: Container(
                                      width: RouteManager.width / 1.2,
                                      height: RouteManager.width / 5.8,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: RouteManager.width / 10,
                                  ),
                                  Container(
                                    width: RouteManager.width / 1.25,
                                    child: Opacity(
                                      opacity: 0.5,
                                      child: TextFormField(
                                        controller: speciality,
                                        style: TextStyle(
                                          fontSize: RouteManager.width / 21,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        decoration: InputDecoration(
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(width: 3, color: Colors.blue), //<-- SEE HERE
                                          ),
                                          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: RouteManager.width / 20),
                                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                                          labelText: " Speciality",
                                          hintText: "Enter Speciality",
                                          hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: RouteManager.width / 20),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return null;
                                          }
                                          if (value.length < 2) {
                                            return "Minimum 2 Characters";
                                          }
                                          if (value.length > 14) {
                                            return "Maximum 14 Characters Allowed";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: RouteManager.height / 25,
                          ),
                          Stack(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: RouteManager.width / 13,
                                  ),
                                  Opacity(
                                    opacity: 0.4,
                                    child: Container(
                                      width: RouteManager.width / 1.2,
                                      height: RouteManager.width / 5.8,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: RouteManager.width / 10,
                                  ),
                                  Container(
                                    width: RouteManager.width / 1.25,
                                    child: Opacity(
                                      opacity: 0.5,
                                      child: TextFormField(
                                        controller: name,
                                        style: TextStyle(
                                          fontSize: RouteManager.width / 21,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        decoration: InputDecoration(
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(width: 3, color: Colors.blue), //<-- SEE HERE
                                          ),
                                          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: RouteManager.width / 20),
                                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                                          labelText: " Name",
                                          hintText: "Enter Name",
                                          hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: RouteManager.width / 20),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return null;
                                          }
                                          if (value.length < 4) {
                                            return "Minimum 4 Characters";
                                          }
                                          if (value.length > 14) {
                                            return "Maximum 14 Characters Allowed";
                                          }
                                          if (value.contains(RegExp(r'[0-9]'))) {
                                            return 'No Digits Allowed';
                                          }
                                          if (value.contains(RegExp(r'[^A-Za-z0-9\s]'))) {
                                            return 'No Special Characters Allowed';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // SizedBox(
                          //   height: RouteManager.height / 25,
                          // ),
                          // Stack(
                          //   children: [
                          //     Row(
                          //       children: [
                          //         SizedBox(
                          //           width: RouteManager.width / 13,
                          //         ),
                          //         Opacity(
                          //           opacity: 0.4,
                          //           child: Container(
                          //             width: RouteManager.width / 1.2,
                          //             height: RouteManager.width / 5.8,
                          //             color: Colors.white,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //     Row(
                          //       children: [
                          //         SizedBox(
                          //           width: RouteManager.width / 10,
                          //         ),
                          //         Container(
                          //           width: RouteManager.width / 1.25,
                          //           child: Opacity(
                          //             opacity: 0.5,
                          //             child: TextFormField(

                          //               controller: username,
                          //               style: TextStyle(
                          //                 fontSize: RouteManager.width / 21,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //               decoration: InputDecoration(
                          //                 enabledBorder: const OutlineInputBorder(
                          //           borderSide: BorderSide(width: 3, color: Colors.blue), //<-- SEE HERE
                          //         ),
                          //                 labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: RouteManager.width / 20),
                          //                 floatingLabelBehavior: FloatingLabelBehavior.auto,
                          //                 labelText: " Username",
                          //                 hintText: "Enter Username",
                          //                 hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: RouteManager.width / 20),
                          //               ),
                          //               validator: (value) {
                          //                 if (value!.isEmpty) {
                          //                   return null;
                          //                 }
                          //                 if (value.length < 4) {
                          //                   return "Minimum 4 Characters";
                          //                 }
                          //                 if (value.length > 14) {
                          //                   return "Maximum 14 Characters Allowed";
                          //                 }
                          //                 if (value.contains(' ')) {
                          //                   return 'No Spaces Allowed';
                          //                 }
                          //                 if (value.contains(RegExp(r'[^A-Za-z0-9\s]'))) {
                          //                   return 'No Special Characters Allowed';
                          //                 }
                          //                 return null;
                          //               },
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ],
                          // ),
                          SizedBox(
                            height: RouteManager.height / 25,
                          ),
                          Stack(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: RouteManager.width / 13,
                                  ),
                                  Opacity(
                                    opacity: 0.4,
                                    child: Container(
                                      width: RouteManager.width / 1.2,
                                      height: RouteManager.width / 5.8,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: RouteManager.width / 10,
                                  ),
                                  Container(
                                    width: RouteManager.width / 1.25,
                                    child: Opacity(
                                      opacity: 0.5,
                                      child: TextFormField(
                                        controller: email,
                                        style: TextStyle(
                                          fontSize: RouteManager.width / 21,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        decoration: InputDecoration(
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(width: 3, color: Colors.blue), //<-- SEE HERE
                                          ),
                                          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: RouteManager.width / 20),
                                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                                          labelText: " Email",
                                          hintText: "Enter Email",
                                          hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: RouteManager.width / 20),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return null;
                                          }
                                          if (value.length < 4) {
                                            return "Minimum 4 Characters";
                                          }
                                          // if (value.length > 14) {
                                          //   return "Maximum 14 Characters Allowed";
                                          // }
                                          // if (!value.contains('@')) {
                                          //   return 'Invalid Email';
                                          // }
                                          if (!value.contains(RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$"))) {
                                            return 'Invalid Email';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: RouteManager.height / 25,
                          ),
                          Stack(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: RouteManager.width / 13,
                                  ),
                                  Opacity(
                                    opacity: 0.4,
                                    child: Container(
                                      width: RouteManager.width / 1.2,
                                      height: RouteManager.width / 5.8,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: RouteManager.width / 10,
                                  ),
                                  Container(
                                    width: RouteManager.width / 1.25,
                                    child: Opacity(
                                      opacity: 0.5,
                                      child: TextFormField(
                                        obscureText: Provider.of<SignUpPro>(context).obscure1,
                                        controller: pwd,
                                        style: TextStyle(
                                          fontSize: RouteManager.width / 21,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        decoration: InputDecoration(
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(width: 3, color: Colors.blue), //<-- SEE HERE
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(Provider.of<SignUpPro>(context).obscure1 ? Icons.visibility_off : Icons.visibility),
                                            onPressed: () {
                                              Provider.of<SignUpPro>(context, listen: false).obscure1 = !Provider.of<SignUpPro>(context, listen: false).obscure1;
                                              Provider.of<SignUpPro>(context, listen: false).notifyListenerz();
                                              // setState(() {
                                              //   obscure1 = !obscure1;
                                              // });
                                            },
                                          ),
                                          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: RouteManager.width / 20),
                                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                                          labelText: " Password",
                                          hintText: "Enter Password",
                                          hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: RouteManager.width / 20),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return null;
                                          }
                                          if (value.length < 8) {
                                            return "Minimum 8 Characters";
                                          }
                                          if (!value.contains(RegExp(r'^[0-9a-zA-Z]+$'))) {
                                            return 'No Special Characters';
                                          }
                                          if (value.length > 14) {
                                            return "Maximum 14 Characters Allowed";
                                          }
                                          // if(value.contains(' '))
                                          // {
                                          //   return 'No Spaces Allowed';
                                          // }
                                          if (!value.contains(RegExp(r'[0-9]'))) {
                                            return 'Use Atleast One Digit 0-9';
                                          }
                                          // if (value.contains(RegExp(r'[^A-Za-z0-9\s]'))) {
                                          //   return 'No Special Characters Allowed';
                                          // }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: RouteManager.height / 25,
                          ),
                          Stack(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: RouteManager.width / 13,
                                  ),
                                  Opacity(
                                    opacity: 0.4,
                                    child: Container(
                                      width: RouteManager.width / 1.2,
                                      height: RouteManager.width / 5.8,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: RouteManager.width / 10,
                                  ),
                                  Container(
                                    width: RouteManager.width / 1.25,
                                    child: Opacity(
                                      opacity: 0.5,
                                      child: TextFormField(
                                        obscureText: Provider.of<SignUpPro>(context).obscure2,
                                        controller: pwd2,
                                        style: TextStyle(
                                          fontSize: RouteManager.width / 21,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        decoration: InputDecoration(
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(width: 3, color: Colors.blue), //<-- SEE HERE
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(Provider.of<SignUpPro>(context).obscure2 ? Icons.visibility_off : Icons.visibility),
                                            onPressed: () {
                                              Provider.of<SignUpPro>(context, listen: false).obscure2 = !Provider.of<SignUpPro>(context, listen: false).obscure2;
                                              Provider.of<SignUpPro>(context, listen: false).notifyListenerz();
                                              // setState(() {
                                              //   obscure1 = !obscure1;
                                              // });
                                            },
                                          ),
                                          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: RouteManager.width / 20),
                                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                                          labelText: " Confirm Password",
                                          hintText: "Re-enter Password",
                                          hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: RouteManager.width / 20),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return null;
                                          }
                                          if (value != pwd.text) {
                                            return "Passwords do not Match";
                                          }
                                          // if (value.length > 14) {
                                          //   return "Maximum 14 Characters Allowed";
                                          // }
                                          // if(value.contains(' '))
                                          // {
                                          //   return 'No Spaces Allowed';
                                          // }
                                          // if (!value.contains(RegExp(r'[0-9]'))) {
                                          //   return 'Use Atleast One Digit 0-9';
                                          // }
                                          // if (value.contains(RegExp(r'[^A-Za-z0-9\s]'))) {
                                          //   return 'No Special Characters Allowed';
                                          // }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: RouteManager.height / 25,
                    ),

                    InkWell(
                      onTap: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf', 'docx'],
                        );
                        if (result != null) {
                          if (result.files.single.extension != "pdf" && result.files.single.extension != "docx") {
                            ft.Fluttertoast.showToast(
                              msg: "Please select a valid File",
                              toastLength: ft.Toast.LENGTH_LONG,
                            );
                            return;
                          }
                          File file = File(result.files.single.path!);
                          Provider.of<SignUpPro>(context, listen: false).extension = result.files.single.extension!;
                          Provider.of<SignUpPro>(context, listen: false).cv = file;
                          Provider.of<SignUpPro>(context, listen: false).notifyListenerz();
                          print("SELECTEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD : : : : : " + file.path.toString());
                          print("SELECTEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD : : : : : " + result.files.single.extension!);
                        }
                      },
                      child: Container(
                        width: RouteManager.width / 1.3,
                        height: RouteManager.width / 5,
                        color: Color.fromARGB(255, 228, 228, 228),
                        child: Provider.of<SignUpPro>(context).cv == null
                            ? Center(child: Text("Tap Here to Upload CV", style: TextStyle(fontSize: RouteManager.width / 19, color: Colors.blue)))
                            : Center(
                                child: Text(Provider.of<SignUpPro>(context).cv!.path.split('/')[Provider.of<SignUpPro>(context).cv!.path.split('/').length - 1].toString(),
                                    style: TextStyle(fontSize: RouteManager.width / 19, color: Colors.green))),
                      ),
                    ),

                    SizedBox(
                      height: RouteManager.height / 25,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(52, 109, 199, 10),
                      ),
                      onPressed: () async {
                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //   RouteManager.bottomnavigationpage,
                        //   (route) => false,
                        // );
                        // return;
                        //////////////////////////////////////////////////////////////////////////////////////////
                        FocusManager.instance.primaryFocus?.unfocus();
                        final isvalidform = formkey.currentState!.validate();
                        if (isvalidform) {
                          if (Provider.of<SignUpPro>(context, listen: false).dp == null) {
                            ft.Fluttertoast.showToast(
                              msg: "Please Add Photo",
                              toastLength: ft.Toast.LENGTH_LONG,
                            );
                            return;
                          }
                          if (Provider.of<SignUpPro>(context, listen: false).cv == null) {
                            ft.Fluttertoast.showToast(
                              msg: "Please Upload CV",
                              toastLength: ft.Toast.LENGTH_LONG,
                            );
                            return;
                          }
                          if (name.text == "" || email.text == "" || pwd.text == "" || pwd2.text == "" || speciality.text=="") {
                            ft.Fluttertoast.showToast(
                              msg: "Please fill all the fields",
                              toastLength: ft.Toast.LENGTH_LONG,
                            );
                            return;
                          }
                          print("VALIDATEDDDDDDDDDDDDDDDDDDDD");
                          API
                              .register(name.text, email.text,speciality.text, pwd.text, pwd2.text, Provider.of<SignUpPro>(context, listen: false).latitude!, Provider.of<SignUpPro>(context, listen: false).longitude!,
                                  Provider.of<SignUpPro>(context, listen: false).dp!, Provider.of<SignUpPro>(context, listen: false).cv!, context)
                              .then((value) {
                            if (value) {
                              Provider.of<SignUpPro>(context, listen: false).clearAll();
                              name.text = "";
                              email.text = "";
                              pwd.text = "";
                              pwd2.text = "";
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                RouteManager.homepage,
                                (route) => false,
                              );
                            }
                          });
                          /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        }
                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //   RouteManager.bottomnavigationpage,
                        //   (route) => false,
                        // );
                        // return;
                        // showDialog(
                        //     barrierDismissible: false,
                        //     context: context,
                        //     builder: (cont) {
                        //       return AlertDialog(
                        //         title: Text("Enter OTP sent to Email"),
                        //         content: Container(
                        //           width: RouteManager.width / 2,
                        //           height: RouteManager.width / 4.2,
                        //           child: Column(
                        //             children: [
                        //               const TextField(
                        //                 decoration: InputDecoration(hintText: "Enter OTP"),
                        //               ),
                        //               ElevatedButton(
                        //                   onPressed: () {
                        //                     Navigator.of(context).pushNamedAndRemoveUntil(
                        //                       RouteManager.bottomnavigationpage,
                        //                       (route) => false,
                        //                     );
                        //                   },
                        //                   child: Text("Submit"))
                        //             ],
                        //           ),
                        //         ),
                        //       );
                        //     });
                      },
                      child: Container(
                        width: RouteManager.width / 1.3,
                        child: Center(
                          child: Text(
                            "Register",
                            style: TextStyle(fontSize: RouteManager.width / 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> _determinePosition() async {
    var pos = await Geolocator.getCurrentPosition();
    return pos.latitude.toString() + "|" + pos.longitude.toString();
  }

  _showDialog(String text) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Stack(
            children: [
              Opacity(
                opacity: 0.2,
                child: Container(
                  width: RouteManager.width,
                  height: RouteManager.height,
                ),
              ),
              Center(
                child: SizedBox(
                  width: RouteManager.width / 2,
                  height: RouteManager.height / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: RouteManager.width / 7, height: RouteManager.width / 7, child: const CircularProgressIndicator(color: Colors.blue)),
                      DefaultTextStyle(
                        style: TextStyle(fontSize: RouteManager.width / 20),
                        child: Text(text),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
