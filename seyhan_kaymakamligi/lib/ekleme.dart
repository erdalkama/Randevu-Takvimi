import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seyhan_kaymakamligi/home_page.dart';

class Ekleme extends StatefulWidget {
  const Ekleme({Key? key}) : super(key: key);

  @override
  State<Ekleme> createState() => _EklemeState();
}

class _EklemeState extends State<Ekleme> {
  TextEditingController randevuController = TextEditingController();
  TextEditingController baslangicController = TextEditingController();
  TextEditingController bitisController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final databaseReference = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    CollectionReference databaseReference = _firestore.collection('Event');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: const Text(
          'VERİ EKLEME',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/seyhan_logo_3.png"),
            colorFilter: ColorFilter.mode(
                Color.fromARGB(29, 114, 114, 114), BlendMode.modulate),
            fit: BoxFit.scaleDown,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(75.0, 20.0, 75.0, 0.0),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Lütfen Randevu Bilgisi Giriniz";
                    }
                    return null;
                  },
                  controller: randevuController,
                  decoration: InputDecoration(
                    hintText: 'Randevu Bilgileri Giriniz',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "00/00/0000 00:00 Formatonda Giriniz";
                    }
                    return null;
                  },
                  controller: baslangicController,
                  decoration: InputDecoration(
                    hintText:
                        'Randevu Başlangıç Saati Giriniz "Gün/Ay/Yıl Saat:Dakika"',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "00/00/0000 00:00 Formatonda Giriniz";
                    }
                    return null;
                  },
                  controller: bitisController,
                  decoration: InputDecoration(
                    hintText:
                        'Randevu Bitiş Saati Giriniz "Gün/Ay/Yıl Saat:Dakika"',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_circle_outline_rounded),
        onPressed: () async {
          Map<String, dynamic> eventData = {
            'Subject': randevuController.text,
            'StartTime': baslangicController.text,
            'EndTime': bitisController.text,
          };
          await databaseReference.doc().set(eventData);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        },
      ),
    );
  }
}
