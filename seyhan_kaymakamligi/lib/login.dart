// ignore_for_file: deprecated_member_use, prefer_const_constructors, unnecessary_new, use_key_in_widget_constructors, unused_import, unused_local_variable, import_of_legacy_library_into_null_safe, unused_field, body_might_complete_normally_nullable

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seyhan_kaymakamligi/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email, _password;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Color.fromARGB(255, 255, 255, 255),
    ));
    return new Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 90.0,
                child: Image.asset('assets/seyhan_logo_3.png'),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontSize: 25.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: 48.0),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (input) {
                  if (input!.isEmpty) {
                    return "Lütfen bir email adresi girin!";
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Email',
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
                onSaved: (input) => _email = input!,
              ),
              SizedBox(height: 8.0),
              TextFormField(
                validator: (input) {
                  if (input!.length < 6) {
                    return "Şifre en az 6 haneli olmalı!";
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Şifre',
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
                onSaved: (input) => _password = input!,
                obscureText: true,
                autofocus: false,
              ),
              SizedBox(height: 24.0),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: signIn,
                  padding: EdgeInsets.all(12),
                  color: Color.fromARGB(129, 0, 0, 0),
                  child: Text('Giriş',
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold)),
                ),
              )
            ],
          )),
    );
  }

  void signIn() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } catch (e) {
          showSimpleDialog();
        }
      }
    } else {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("GİRİŞ YAPILAMIYOR!"),
              content: Text("Lütfen internet bağlantınızı kontrol ediniz."),
            );
          });
    }
  }

  Future<void> showSimpleDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("OTURUM AÇILAMIYOR!"),
            content: Text(
                "Lütfen geçerli bir e-mail ya da şifre giriniz.Şifrenizi unuttuysanız lütfen bizimle iletişime geçiniz."),
            actions: <Widget>[
              FlatButton(
                child: Text("Tamam"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
