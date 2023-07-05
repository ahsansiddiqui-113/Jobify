import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:linkedinproj/Api%20&%20Routes/routes.dart';
import 'package:linkedinproj/Entities/searcheduser.dart';
import 'dart:convert';
import 'dart:io';
import '../Entities/jobobject.dart';
import '../providers/homepro.dart';
import '../providers/profilepro.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../providers/signuppro.dart';

class API {
  static var ip = "http://172.0.2.26:3030/api2/";
  static var imageip = "http://172.0.2.26:8080/";

  static showLoading(String text, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Stack(
            children: [
              Opacity(
                //http://192.168.192.1/1684820711214.jpg
                opacity: 0.2,
                child: SizedBox(
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
                      SizedBox(
                        width: RouteManager.width / 7,
                        height: RouteManager.width / 7,
                        child: const CircularProgressIndicator(),
                      ),
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

  static Future<bool> register(String fullname, String useremail,String speciality, String password, String password2, double lat, double long, File dp, File cv, BuildContext context) async {
    showLoading("Signing Up", context);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("${ip}signup"),
    );
    request.headers.addAll({'Content-type': 'multipart/form-data'});
    request.files.add(await http.MultipartFile.fromPath('dp', dp.path, contentType: MediaType('image', 'jpeg')));
    request.files.add(await http.MultipartFile.fromPath('cv', cv.path));
    String filetype = Provider.of<SignUpPro>(context, listen: false).extension;
    request.fields.addAll({
      'filetype': filetype,
      'name': fullname,
      'email': useremail,
      'speciality':speciality,
      'pwd': password,
      'lat': lat.toString(),
      'lng': long.toString(),
    });
    var response;
    try {
      print("SIGN UP CALLEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
      response = await request.send().timeout(Duration(seconds: 60), onTimeout: () {
        throw "TimeOut";
      });
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        var res = jsonDecode(responsed.body);
        print("RESPONSE IS : : : : : :" + responsed.body.toString());
        Provider.of<ProfilePro>(context, listen: false).userid = res["userid"];
        Provider.of<ProfilePro>(context, listen: false).dp = res["dp"];
        Provider.of<ProfilePro>(context, listen: false).name = res["name"];
        Provider.of<ProfilePro>(context, listen: false).speciality=res["speciality"];
        Provider.of<ProfilePro>(context, listen: false).email = res["email"];
        Provider.of<ProfilePro>(context, listen: false).lat = res["lat"];
        Provider.of<ProfilePro>(context, listen: false).lng = res["lng"];
        print("AAALLLLLLLLLLLLLLL GOOOOOOOOOOOOOOOOOODDDDDDDDDDDDDDDDDDDDDDDDd");
        ft.Fluttertoast.showToast(
          msg: "Sign Up Successful",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        return true;
      } else if (response.statusCode == 302) {
        Navigator.of(context, rootNavigator: true).pop();
        ft.Fluttertoast.showToast(
          msg: "Email Already Registered",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        return false;
      } else {
        print("STATUS CODE IS : : : : : : : : : :" + response.statusCode.toString());
        Navigator.of(context, rootNavigator: true).pop();
        ft.Fluttertoast.showToast(
          msg: "Sign Up Unsuccessful",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        return false;
      }
      // print("AYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAA" + e.toString());
      Navigator.of(context, rootNavigator: true).pop();
      ft.Fluttertoast.showToast(
        msg: "Sign Up Unsuccessful",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      return false;
    }
  }

  static Future<bool> signIn(String email, String pwd, BuildContext context) async {
    if (email == "" || pwd == "") {
      ft.Fluttertoast.showToast(
        msg: "Please fill all the fields",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      return false;
    }

    showLoading("Signing In", context);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("${ip}signin"),
    );
    request.headers.addAll({'Content-type': 'multipart/form-data'});
    request.fields.addAll({
      'email': email,
      'pwd': pwd,
    });
    var response;
    try {
      if (email.contains('\\') || pwd.contains('\\')) {
        throw Exception();
      }
      response = await request.send().timeout(Duration(seconds: 60), onTimeout: () {
        throw "TimeOut";
      });
      var responsed = await http.Response.fromStream(response);
      print("SIGN IN CALLEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
      if (response.statusCode == 200) {
        print("RESPONSE IS : : : : : :" + responsed.body.toString());
        var res = jsonDecode(responsed.body);
        Provider.of<ProfilePro>(context, listen: false).userid = res["userid"];
        Provider.of<ProfilePro>(context, listen: false).dp = res["dp"];
        Provider.of<ProfilePro>(context, listen: false).name = res["name"];
        Provider.of<ProfilePro>(context, listen: false).speciality=res["speciality"];
        Provider.of<ProfilePro>(context, listen: false).email = res["email"];
        Provider.of<ProfilePro>(context, listen: false).lat = res["lat"];
        Provider.of<ProfilePro>(context, listen: false).lng = res["lng"];
        Provider.of<ProfilePro>(context, listen: false).isadmin = res["isadmin"] == 0 ? false : true;
        ft.Fluttertoast.showToast(
          msg: "Sign In Successful",
          toastLength: ft.Toast.LENGTH_SHORT,
        );
        return true;
      } else if (response.statusCode == 201 || response.statusCode == 202) {
        Navigator.of(context, rootNavigator: true).pop();

        ft.Fluttertoast.showToast(
          msg: "Invalid Credentials",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        return false;
      } else {
        print("STATUS CODE IS : : : : : : : : : :" + response.statusCode.toString());
        Navigator.of(context, rootNavigator: true).pop();
        ft.Fluttertoast.showToast(
          msg: "Sign In Unsuccessful",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        return false;
      }
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAA" + e.toString());
      Navigator.of(context, rootNavigator: true).pop();
      ft.Fluttertoast.showToast(
        msg: "Sign In Unsuccessful",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      return false;
    }
  }

  static Future<bool> addPost(int userid, String skills, String cap, File f) async {
    print("ayAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaaaaa");
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("${ip}addPost?userid=$userid"),
    );
    // request.headers.addAll({'Content-type': 'multipart/form-data'});
    request.files.add(await http.MultipartFile.fromPath('postimage', f.path, contentType: MediaType('image', 'jpeg')));
    request.fields.addAll(<String, String>{
      // 'userid': userid.toString(),
      'skills': skills,
      'cap': cap.toString(),
      // 'isprivate': isprivate.toString(),
    });
    var response;
    try {
      // if (cap.contains('\\') || cap.contains('\'') || cap.contains('"') || cap.contains('~') || cap.contains('`')) {
      //   throw Exception();
      // }
      print("ADD POST CALLEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
      response = await request.send().timeout(Duration(seconds: 25), onTimeout: () {
        throw "TimeOut";
      });
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        // var res = jsonDecode(responsed.body);
        // print("RESPONSE IS : : : : : :" + responsed.body.toString());
        ft.Fluttertoast.showToast(
          msg: "Posted",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        // Navigator.of(context, rootNavigator: true).pop();
        return true;
      } else {
        // print("STATUS CODE IS : : : : : : : : : :" + response.statusCode.toString() + responsed.body.toString());
        // Navigator.of(context, rootNavigator: true).pop();
        ft.Fluttertoast.showToast(
          msg: "Failed",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        return false;
      }
      // print("AYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAA" + e.toString());
      // Navigator.of(context, rootNavigator: true).pop();
      ft.Fluttertoast.showToast(
        msg: "Failed",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      return false;
    }
  }
//email sending
  static Future<bool> sendEmail(String name,String email, String title,String company, BuildContext context) async {
    var response;
    try {
      response = await http
          .post(
            Uri.parse(
              "https://api.emailjs.com/api/v1.0/email/send",
            ),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: json.encode(
              {
                'service_id': 'service_sfbehsb',
                'template_id': 'template_obuyc0b',
                'user_id': 'ILhdLzbCIq0Ir7t2U',
                'template_params': {
                  'user_subject': 'Applied for Job',
                  'to_name':name,
                  'title': title,
                  'company': company,
                  'to_email':email,
                }
              },
            ),
          )
          .timeout(const Duration(seconds: 25));
      if (response.statusCode == 200) {
        print("CHALAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
        // print("RESPONSE OF send EMAIL : ::::::::::::::::::::::::::::::::::::::::::::" + jsonDecode(response.body).toString());
        return true;
      } else if (response.statusCode == 412) {
        ft.Fluttertoast.showToast(
          msg: "Invalid Email",
          toastLength: ft.Toast.LENGTH_SHORT,
        );
        return false;
      } else {
        ft.Fluttertoast.showToast(
          msg: "Failed",
          toastLength: ft.Toast.LENGTH_SHORT,
        );
        return false;
      }
    } catch (e) {
      ft.Fluttertoast.showToast(
        msg: "Failed",
        toastLength: ft.Toast.LENGTH_SHORT,
      );
      // print(e.toString() + "############################################################################################################################################################");
      return false;
    }
  }

  static Future<bool> getFeed(int userid, BuildContext context) async {
    var response1;
    try {
      response1 = await http.get(
        Uri.parse(
          ip + "getFeed",
        ).replace(queryParameters: {
          'userid': userid.toString(),
        }),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      ).timeout(const Duration(seconds: 60));
      if (response1.statusCode == 200) {
        var response2;
        try {
          response2 = await http.get(
            Uri.parse(
              "https://serpapi.com/search?engine=google_jobs&q=" +
                  Provider.of<HomePro>(context, listen: false).searches[Provider.of<HomePro>(context, listen: false).page - 10] +
                  "&start=0&api_key=f9b6a609a3810103715e9cf3292355edc74ff277dd1c0a36df0de9b417ccf8b5",
            ),
            headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
          ).timeout(const Duration(seconds: 60));
          if (response2.statusCode == 200) {
            print("AYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
            print("RESPONSE : : : : " + response2.body.toString());
            List<JobObject> newposts = [];
            response1 = jsonDecode(response1.body);
            for (var i in response1) {
              List<String> skilj = [];
              for (var j in i["skills"]) {
                skilj.add(j);
                print("SKILL IS : " + j);
              }
              JobObject po = JobObject(
                i["userid"],
                i["jobid"],
                i["dp"],
                i["name"],
                i["caption"],
                i["pic"],
                skilj,
                true,
              );
              newposts.add(po);
            }
            Provider.of<HomePro>(context, listen: false).jobs = newposts;
            print("RESPONSE OF GETFEED ITEMSSSSSSSSSSSSSSSSSS::::::::::::::::::::::::::::::::::::::::::::" + response1.toString());
            response2 = jsonDecode(response2.body);
            List<JobObject> ojlist = [];
            for (var i in response2["jobs_results"]) {
              ojlist.add(
                JobObject.OtherObject(
                  i["company_name"],
                  i["title"],
                  i["description"],
                  false,
                ),
              );
            }
            Provider.of<HomePro>(context, listen: false).jobs += ojlist;
            return true;
          } else {
            throw Exception();
          }
        } catch (e) {
          print(e.toString() + "############################################################################################################################################################");
          return false;
        }
      } else {
        print(response1.statusCode + "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        throw Exception();
      }
    } catch (e) {
      print(e.toString() + "############################################################################################################################################################");
      return false;
    }
  }

  static Future<bool> getSERPFeed(int page, BuildContext context) async {
    print("AYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    var response;
    try {
      response = await http.get(
        Uri.parse(
          "https://serpapi.com/search?engine=google_jobs&q=" +
              Provider.of<HomePro>(context, listen: false).searches[Provider.of<HomePro>(context, listen: false).page - 10] +
              "&start=" +
              page.toString()+"&api_key=f9b6a609a3810103715e9cf3292355edc74ff277dd1c0a36df0de9b417ccf8b5",
        ),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      ).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        response = jsonDecode(response.body);
        List<JobObject> ojlist = [];
        for (var i in response["jobs_results"]) {
          ojlist.add(
            JobObject.OtherObject(
              i["company_name"],
              i["title"],
              i["description"],
              false,
            ),
          );
        }
        Provider.of<HomePro>(context, listen: false).jobs += ojlist;
        return true;
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e.toString() + "############################################################################################################################################################");
      return false;
    }
  }

  static Future<bool> getMyPosts(int userid, BuildContext context) async {
    var response;
    try {
      response = await http.get(
        Uri.parse(
          ip + "getMyPosts",
        ).replace(queryParameters: {
          'userid': userid.toString(),
        }),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      ).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        List<JobObject> newposts = [];
        response = jsonDecode(response.body);
        for (var i in response) {
          List<String> skilj = [];
          for (var j in i["skills"]) {
            skilj.add(j);
            print("SKILL IS : " + j);
          }
          JobObject po = JobObject(
            i["userid"],
            i["jobid"],
            i["dp"],
            i["name"],
            i["caption"],
            i["pic"],
            skilj,
            true,
          );
          newposts.add(po);
        }
        Provider.of<ProfilePro>(context, listen: false).jobs = newposts;
        print("RESPONSE OF GETFEED ITEMSSSSSSSSSSSSSSSSSS::::::::::::::::::::::::::::::::::::::::::::" + response.toString());
        return true;
      } else {
        print(response.statusCode + "%%%%%%%%%%%%%%%%%%%%%%%%%");
        throw Exception();
      }
    } catch (e) {
      print(e.toString() + "####################");
      return false;
    }
  }

  static Future<bool> getFeedByDistance(int userid, double lat, double lng, double distance, BuildContext context) async {
    var response;
    try {
      response = await http.get(
        Uri.parse(
          ip + "getFeedbydistance",
        ).replace(queryParameters: {
          'userid': userid.toString(),
          'lat': lat.toString(),
          'lng': lng.toString(),
          'distance': distance.toString(),
        }),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      ).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        List<JobObject> newposts = [];
        response = jsonDecode(response.body);
        for (var i in response) {
          List<String> skilj = [];
          for (var j in i["skills"]) {
            skilj.add(j);
            print("SKILL IS : " + j);
          }
          JobObject po = JobObject(
            i["userid"],
            i["jobid"],
            i["dp"],
            i["name"],
            i["caption"],
            i["pic"],
            skilj,
            true,
          );
          newposts.add(po);
        }
        Provider.of<HomePro>(context, listen: false).jobs = newposts;
        print("RESPONSE OF GETFEED ITEMSSSSSSSSSSSSSSSSSS::::::::::::::::::::::::::::::::::::::::::::" + response.toString());
        return true;
      } else {
        print(response.statusCode + "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        throw Exception();
      }
    } catch (e) {
      print(e.toString() + "#####################################################################");
      return false;
    }
  }

  static Future<bool> searchJobs(int userid, double lat, double lng, int limit, BuildContext context) async {
    var response;
    try {
      response = await http.get(
        Uri.parse(
          ip + "searchJobs",
        ).replace(queryParameters: {
          'userid': userid.toString(),
          'lat': lat.toString(),
          'lng': lng.toString(),
          'limit': limit.toString(),
        }),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      ).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        print("RESPONSE OF SEARCHHH USERSSSSSSSSSSSSSSSSS:::" + response.body.toString());
        List<SearchedUser> users = [];
        response = jsonDecode(response.body);
        Set<Marker> mymarkers = {};
        for (var i in response) {
          users.add(SearchedUser(
            i["userid"],
            i["name"],
            i["dp"],
            i["lat"],
            i["lng"],
            double.parse(i["distance"].toString()),
            i["jobs"],
          ));
          print("helloooooooooooooooooooooooooo" + i["dp"]);
          final File markerImageFile = await DefaultCacheManager().getSingleFile("http://172.0.2.26/" + i["dp"]);
          print("yaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
          final Uint8List markerImageBytes = await markerImageFile.readAsBytes();
          final markerImageCodec = await instantiateImageCodec(
            markerImageBytes,
            targetWidth: 100,
          );
          final FrameInfo frameInfo = await markerImageCodec.getNextFrame();
          final byteData = await frameInfo.image.toByteData(
            format: ImageByteFormat.png,
          );
          final Uint8List resizedMarkerImageBytes = byteData!.buffer.asUint8List();

          mymarkers.add(
            Marker(
              markerId: MarkerId(i["lat"].toString() + i["lng"].toString()),
              infoWindow: InfoWindow(title: i["name"] + " +" + i["jobs"].toString() + " Jobs"),
              icon: BitmapDescriptor.fromBytes(resizedMarkerImageBytes),
              position: LatLng(
                i["lat"],
                i["lng"],
              ),
            ),
          );
         
          print("DISTANCE IS : " + i["distance"].toString());
        }
        Provider.of<HomePro>(context, listen: false).markers = mymarkers;
        Provider.of<HomePro>(context, listen: false).users = users;
        return true;
      } else {
        print(response.statusCode + "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        throw Exception();
      }
    } catch (e) {
      print(e.toString() + "############################################################################################################################################################");
      return false;
    }
  }

  static Future<bool> deleteMyJob(int userid) async {
    var response;
    try {
      response = await http.post(
        Uri.parse(
          ip + "deleteMyJob",
        ).replace(queryParameters: {
          'jobid': userid.toString(),
        }),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      ).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        return true;
      } else {
        ft.Fluttertoast.showToast(
          msg: "Failed",
          toastLength: ft.Toast.LENGTH_SHORT,
        );
        print(response.statusCode + "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        throw Exception();
      }
    } catch (e) {
      ft.Fluttertoast.showToast(
        msg: "Failed",
        toastLength: ft.Toast.LENGTH_SHORT,
      );
      print(e.toString() + "############################################################################################################################################################");
      return false;
    }
  }

  static Future<bool> updatePassword(int userid, String pwd) async {
    var response;
    try {
      response = await http.post(
        Uri.parse(
          ip + "updatePassword",
        ).replace(queryParameters: {
          'userid': userid.toString(),
          'pwd': pwd.toString(),
        }),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      ).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        ft.Fluttertoast.showToast(
          msg: "Password Changed",
          toastLength: ft.Toast.LENGTH_SHORT,
        );
        return true;
      } else {
        ft.Fluttertoast.showToast(
          msg: "Failed",
          toastLength: ft.Toast.LENGTH_SHORT,
        );
        print(response.statusCode + "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        throw Exception();
      }
    } catch (e) {
      ft.Fluttertoast.showToast(
        msg: "Failed",
        toastLength: ft.Toast.LENGTH_SHORT,
      );
      print(e.toString() + "############################################################################################################################################################");
      return false;
    }
  }

  static Future<bool> updateDp(int userid, File dp, BuildContext context) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("${ip}updateDp?userid=$userid"),
    );
    request.headers.addAll({'Content-type': 'multipart/form-data'});
    request.files.add(await http.MultipartFile.fromPath('dp', dp.path, contentType: MediaType('image', 'jpeg')));
    var response;
    try {
      print("Update DP CALLEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
      response = await request.send().timeout(Duration(seconds: 60), onTimeout: () {
        throw "TimeOut";
      });
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        // var res = jsonDecode(responsed.body);
        print("RESPONSE IS : : : : : : : : : : : : : : : : : :" + responsed.body.toString());
        Provider.of<ProfilePro>(context, listen: false).dp = API.imageip + responsed.body;
        ft.Fluttertoast.showToast(
          msg: "Dp Updated",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        Provider.of<ProfilePro>(context, listen: false).notifyListenerz();
        Navigator.of(context, rootNavigator: true).pop();
        return true;
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        ft.Fluttertoast.showToast(
          msg: "Failed 1" + responsed.body.toString() + ":" + response.statusCode.toString(),
          toastLength: ft.Toast.LENGTH_LONG,
        );
        return false;
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      ft.Fluttertoast.showToast(
        msg: "Failed 2",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      return false;
    }
  }
}
