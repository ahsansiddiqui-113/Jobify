import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linkedinproj/providers/signinpro.dart';
import 'package:linkedinproj/providers/signuppro.dart';
import 'package:provider/provider.dart';
import 'Api & Routes/routes.dart';
import 'providers/bottomnavpro.dart';
import 'providers/homepro.dart'; 
import 'providers/profilepro.dart';
import 'providers/uploadpostpro.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]); 
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<BottomNavigationPro>(create: (BuildContext context) => BottomNavigationPro()),
        ChangeNotifierProvider<SignInPro>(create: (BuildContext context) => SignInPro()),
        ChangeNotifierProvider<SignUpPro>(create: (BuildContext context) => SignUpPro()),
        ChangeNotifierProvider<ProfilePro>(create: (BuildContext context) => ProfilePro()),
        ChangeNotifierProvider<HomePro>(create: (BuildContext context) => HomePro()),
        ChangeNotifierProvider<UploadPostPro>(create: (BuildContext context) => UploadPostPro()),
      ],
      child: MyApp(),
    ),
  );
  // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RouteManager.width = MediaQuery.of(context).size.width;
    RouteManager.height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // const Color.fromARGB(255, 243, 168, 56)
          // primaryColor: Color.fromARGB(255, 243, 168, 56),
          ),
      initialRoute: RouteManager.rootpage,
      onGenerateRoute: RouteManager.generateRoute,
    );
  }
}

