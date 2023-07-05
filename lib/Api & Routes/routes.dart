import 'package:flutter/material.dart';
import 'package:linkedinproj/pages/changepwd.dart';
import 'package:linkedinproj/pages/home.dart';
import 'package:linkedinproj/pages/profile.dart';
import '../Pages/bottomnavigation.dart';
import '../Pages/signin.dart';
import '../Pages/signup.dart';
import '../pages/splashscreen.dart';
import '../pages/uploadpost.dart';

class RouteManager {
  static var width;
  static var height;
  static const String rootpage = "/";
  static const String signinpage = "/signin";
  static const String profilepage = "/profile";
  static const String signuppage = "/signup";
  static const String homepage = "/bottomnav";
  static const String uploadpost = "/uploadpost";
  static const String searchuser = "/searchuser";
  static const String changepwd = "/changepwd";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case rootpage:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case signinpage:
        return MaterialPageRoute(builder: (context) => Signin());
      case signuppage:
        return MaterialPageRoute(builder: (context) => Signup());
      case profilepage:
        return MaterialPageRoute(builder: (context) => Profile());
      case uploadpost:
        return MaterialPageRoute(builder: (context) => UploadPost());

      case homepage:
        return MaterialPageRoute(builder: (context) => Home());
      case changepwd:
        return MaterialPageRoute(builder: (context) => ChangePassword());
      default:
        throw const FormatException("Route no Found!");
    }
  }
}
