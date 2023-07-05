import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:provider/provider.dart';
import '../Api & Routes/api.dart';
import '../Api & Routes/routes.dart';
import '../Providers/signinpro.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool navvalue = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedSplashScreen.withScreenRouteFunction(
        screenRouteFunction: () async {
          RouteManager.width = MediaQuery.of(context).size.width;
          RouteManager.height = MediaQuery.of(context).size.height;
          return Future.value("/signin");
        },
        disableNavigation: navvalue,
        splashTransition: SplashTransition.rotationTransition,
        splash: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            "images/appicon.png",
          ),
        ),
        curve: Curves.easeInOutCubic,
        splashIconSize: 100,
        centered: true,
        animationDuration: const Duration(seconds: 2),
        backgroundColor: Colors.black,
      ),
    );
  }
}
