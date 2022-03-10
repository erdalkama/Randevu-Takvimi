// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

import 'randevu.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          title: Text(
            'STAJ PROJESİ',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
      IconButton(
      onPressed: () {
        Navigator.push(
    context, MaterialPageRoute(builder: (context) => Bekleyenler()));
    },
    icon: Icon(Icons.date_range_rounded,
  ),
      )
  ]
          ),
          body: Container(
               decoration: BoxDecoration(
                image: DecorationImage(
                 image: AssetImage("assets/seyhan_logo_3.png"),
                 fit: BoxFit.scaleDown,
               ),
            ),
          ),
    );
  }
}