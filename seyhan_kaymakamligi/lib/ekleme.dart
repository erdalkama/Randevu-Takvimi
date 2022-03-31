// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:seyhan_kaymakamligi/home_page.dart';
import 'package:seyhan_kaymakamligi/kullanici_adi.dart';

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
  late String dateBaslangic;
  late String dateBitis;

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
                DateTimePicker(
                  cursorColor: Colors.black,
                  type: DateTimePickerType.dateTimeSeparate,
                  dateMask: 'dd/MM/yyyy',
                  initialValue: '',
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  dateLabelText: 'Gün',
                  timeLabelText: 'Saat',
                  onChanged: (val) {
                    print(val);
                    dateBaslangic = val;
                  },
                  validator: (val) {
                    print(val);
                    return null;
                  },
                  onSaved: (val) => print(val),
                ),
                const SizedBox(height: 20.0),
                DateTimePicker(
                  type: DateTimePickerType.dateTimeSeparate,
                  dateMask: 'dd/MM/yyyy',
                  initialValue: '',
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  dateLabelText: 'Gün',
                  timeLabelText: 'Saat',
                  onChanged: (val) {
                    print(val);
                    dateBitis = val;
                  },
                  validator: (val) {
                    print(val);
                    return null;
                  },
                  onSaved: (val) => print(val),
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
            'StartTime': dateBaslangic,
            'EndTime': dateBitis,
            'kayit_tarihi': DateTime.now(),
            'EtkinlikOluşturanKişi': Kullanicikaydi.email,
          };
          await databaseReference.doc().set(eventData);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        },
      ),
    );
  }
}
