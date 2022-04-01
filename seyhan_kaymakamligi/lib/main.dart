// ignore_for_file: unused_import, prefer_const_constructors, use_key_in_widget_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:seyhan_kaymakamligi/ekleme.dart';
import 'package:seyhan_kaymakamligi/randevu.dart';
import 'package:seyhan_kaymakamligi/splash.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
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
      // ignore: prefer_const_literals_to_create_immutables
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        SfGlobalLocalizations.delegate,
      ],
      // ignore: prefer_const_literals_to_create_immutables
      supportedLocales: [
        const Locale('tr'),
        const Locale('en'),
      ],
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 0, 0, 0),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Color.fromARGB(255, 0, 0, 0)),
      ),
      home: AnimatedSplashScreen(),
      locale: const Locale('tr'),
      debugShowCheckedModeBanner: false,
    );
  }
}

var rotalar = <String, WidgetBuilder>{
  "/animated": (BuildContext context) => AnimatedSplashScreen(),
  "/login": (BuildContext context) => LoginPage(),
  "/homepage": (BuildContext context) => HomePage(),
};
