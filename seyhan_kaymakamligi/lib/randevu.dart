// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Bekleyenler extends StatelessWidget {
const Bekleyenler({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          title: Text(
            'RANDEVU BEKLEYENLER LİSTESİ',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          ),
          body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('data1').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
  
          return ListView(
            children: snapshot.data!.docs.map((document) {
              return Container(
                child: Center(child: Text(document['text'])),
              );
            }).toList(),
          );
        },
      ),
);
  }
}