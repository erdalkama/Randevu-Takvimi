// ignore_for_file: prefer_const_constructors, must_be_immutable, deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Bekleyenler extends StatelessWidget {
  Bekleyenler({Key? key}) : super(key: key);
  final _firestore = FirebaseFirestore.instance;
  TextEditingController adsoyadController = TextEditingController();
  TextEditingController konuController = TextEditingController();
  TextEditingController telefonController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    CollectionReference bekleyenlerRef = _firestore.collection('data1');
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/seyhan_logo_3.png"),
            colorFilter: const ColorFilter.mode(
                Color.fromARGB(29, 114, 114, 114), BlendMode.modulate),
            fit: BoxFit.scaleDown,
          ),
        ),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: bekleyenlerRef.orderBy('kayit_tarihi',descending: false).snapshots(),
              builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                if (asyncSnapshot.hasError) {
                  return Center(
                      child: Text('Bir Hata Oluştu, Tekrar Deneyiniz'));
                } else {
                  if (asyncSnapshot.hasData) {
                    List<DocumentSnapshot> listOfDocumentSnap =
                        asyncSnapshot.data.docs;
                    return Flexible(
                      child: ListView.builder(
                        itemCount: listOfDocumentSnap.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                      '${listOfDocumentSnap[index]['adsoyad']}',
                                      style: TextStyle(fontSize: 20)),
                                  subtitle: Text(
                                      '${listOfDocumentSnap[index]['konu']}',
                                      style: TextStyle(fontSize: 16)),
                                  leading: Text(
                                      '${listOfDocumentSnap[index]['telefon']}',
                                      style: TextStyle(fontSize: 16)),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete_forever),
                                    onPressed: () async {
                                      await listOfDocumentSnap[index]
                                          .reference
                                          .delete();
                                    },
                                  ),
                                ),
                              ),
                              /*ButtonBar(
                                children: [
                                  FlatButton(
                                      onPressed: () async {},
                                      child: Text("Güncelle",
                                          style:
                                              TextStyle(color: Colors.black)))
                                ],
                              )*/
                            ],
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 20.0, 75.0, 10.0),
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: adsoyadController,
                      decoration: InputDecoration(
                        hintText: 'Ad Soyad Ünvan Giriniz',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                    TextFormField(
                      controller: konuController,
                      decoration: InputDecoration(
                        hintText: 'Randevu Konusu Giriniz',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                    TextFormField(
                      controller: telefonController,
                      decoration: InputDecoration(
                        hintText: 'Telefon Numarası Giriniz',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_circle_outline_rounded),
        onPressed: () async {
          Map<String, dynamic> data1Data = {
            'telefon': telefonController.text,
            'adsoyad': adsoyadController.text,
            'konu': konuController.text,
            'kayit_tarihi':DateTime.now(),
          };
          await bekleyenlerRef.doc().set(data1Data);
        },
      ),
    );
  }
}
