// ignore_for_file: unused_import, prefer_const_constructors, use_key_in_widget_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:seyhan_kaymakamligi/randevu.dart';
import 'package:seyhan_kaymakamligi/splash.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'home_page.dart';
import 'login.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(AnaGiris());
}
class AnaGiris extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 255, 255, 255), 
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color.fromARGB(255, 0, 0, 0)),
      ),
      home: Bekleyenler(),
      debugShowCheckedModeBanner: false,
    );
  }
}


var rotalar = <String, WidgetBuilder>{
  "/animated":(BuildContext context) => AnimatedSplashScreen(),
  "/login": (BuildContext context) => LoginPage(),
  "/homepage": (BuildContext context) => HomePage(),
};