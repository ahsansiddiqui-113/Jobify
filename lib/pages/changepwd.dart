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

class ChangePassword extends StatefulWidget {
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController pwd = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        pwd.text = "";
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Provider.of<HomePro>(context).isdarkmode ? Colors.grey : Colors.blue,
            title: Row(
              children: [
                SizedBox(
                  width: RouteManager.width / 8,
                ),
                Text("Change Password", style: TextStyle(fontSize: RouteManager.width / 20)),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: RouteManager.width / 1.5,
                ),
                Center(
                  child: SizedBox(
                    width: RouteManager.width / 1.15,
                    child: Form(
                      key: formkey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: TextFormField(
                        controller: pwd,
                        style: TextStyle(
                          fontSize: RouteManager.width / 21,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          enabledBorder:  OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: Provider.of<HomePro>(context).isdarkmode ? Colors.grey : Colors.blue,),
                          ),
                          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: RouteManager.width / 20),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: " New Password",
                          hintText: "Enter New Password",
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
                          if (!value.contains(RegExp(r'[0-9]'))) {
                            return 'Use Atleast One Digit 0-9';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: RouteManager.width / 15,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Provider.of<HomePro>(context).isdarkmode ? Colors.grey : Colors.blue,
                  ),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    final isvalidform = formkey.currentState!.validate();
                    if (isvalidform) {
                      API.showLoading("", context);
                      API.updatePassword(Provider.of<ProfilePro>(context, listen: false).userid, pwd.text).then((value) {
                        if (value) {
                          Navigator.of(context, rootNavigator: true).pop();
                        }
                        Navigator.of(context, rootNavigator: true).pop();
                      });
                    }
                  },
                  child: Text(
                    "Change",
                    style: TextStyle(fontSize: RouteManager.width / 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
