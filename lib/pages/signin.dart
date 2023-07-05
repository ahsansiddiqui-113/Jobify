import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../Api & Routes/api.dart';
import '../Api & Routes/routes.dart';
import '../providers/signinpro.dart';

class Signin extends StatefulWidget {
  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final formkey2 = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController pwd = TextEditingController();

  @override
  Widget build(BuildContext cont) {
    print("SIGN IN WIDGET IS REBUILTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
    RouteManager.width = MediaQuery.of(cont).size.width;
    RouteManager.height = MediaQuery.of(cont).size.height;
    return WillPopScope(
      onWillPop: () async {
        Provider.of<SignInPro>(cont, listen: false).clearAll();
        email.text = "";
        pwd.text = "";
        SystemNavigator.pop();
        // Navigator.of(context).pop(true);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            // reverse: true,
            child: Stack(
              children: [
                Container(
                  height: RouteManager.height,
                  width: RouteManager.width,
                  color: Colors.white,
                  // child: Image.asset("assets/images/newbackground.jpg", fit: BoxFit.fill),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: RouteManager.width / 4,
                    ),
                    Container(child:Image.asset("images/appicon.png"),
                    ),
                    SizedBox(
                      height: RouteManager.height / 30,
                    ),
                    Opacity(
                      opacity: 0.4,
                      child: Container(
                        width: RouteManager.width / 1.1,
                        height: RouteManager.width / 5.53,
                        color: Colors.white,
                        child: Row(
                          children: [
                            SizedBox(
                              width: RouteManager.width / 1.1,
                              height: RouteManager.width / 5.4,
                              child: TextFormField(
                                controller: email,
                                style: TextStyle(
                                  fontSize: RouteManager.width / 22,
                                ),
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 3, color: Colors.blue), //<-- SEE HERE
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: RouteManager.width / 16),
                                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                                  labelText: "Email",
                                  hintText: "Enter Email",
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: RouteManager.width / 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: RouteManager.height / 25,
                    ),
                    Opacity(
                      opacity: 0.4,
                      child: Container(
                        width: RouteManager.width / 1.1,
                        height: RouteManager.width / 5.53,
                        color: Colors.white,
                        child: Row(
                          children: [
                            SizedBox(
                              width: RouteManager.width / 1.1,
                              height: RouteManager.width / 5.4,
                              child: TextFormField(
                                obscureText: Provider.of<SignInPro>(cont).obscure,
                                controller: pwd,
                                style: TextStyle(
                                  fontSize: RouteManager.width / 22,
                                ),
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 3, color: Colors.blue), //<-- SEE HERE
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(Provider.of<SignInPro>(context).obscure ? Icons.visibility_off : Icons.visibility),
                                    onPressed: () {
                                      Provider.of<SignInPro>(context, listen: false).obscure = !Provider.of<SignInPro>(context, listen: false).obscure;
                                      Provider.of<SignInPro>(context, listen: false).notifyListenerz();
                                      // setState(() {
                                      //   obscure1 = !obscure1;
                                      // });
                                    },
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: RouteManager.width / 16),
                                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                                  labelText: "Password",
                                  hintText: "Enter Password",
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: RouteManager.width / 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                             SizedBox(
                      height: RouteManager.width / 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(52, 109, 199, 10),
                      ),
                      onPressed: () {
                        API.signIn(email.text, pwd.text, context).then((value) {
                          if (value) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              RouteManager.homepage,
                              (route) => false,
                            );
                          }
                        });
                      },
                      child: Container(
                        width: RouteManager.width / 1.3,
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: RouteManager.width / 14),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: RouteManager.width / 30,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: RouteManager.width / 6,
                        ),
                        Text(
                          "Dont't have an account? ",
                          style: TextStyle(
                            fontSize: RouteManager.width / 24,
                          ),
                        ),
                        InkWell(
                          child: Text(
                            "Register",
                            style: TextStyle(
                              fontSize: RouteManager.width / 24,
                              color: const Color.fromRGBO(52, 109, 199, 10),
                            ),
                          ),
                          onTap: () {
                            // _handleLocationPermission().then((value) {
                            //   if (value) {
                            _handleLocationPermission().then((value) {
                              if (value) {
                                Navigator.of(context).pushNamed(RouteManager.signuppage);
                              }
                            });
                            // Navigator.of(context).pushNamed(RouteManager.signuppage);
                            // }
                            // });
                          },
                        ),
                      ],
                    )
                  ],
                ),
                
              ],
            ),
          ),
         
        ),
      ),
    );
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
}
