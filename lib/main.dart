import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/auth/auth.dart';
import 'package:chat_app/screens/home.dart';
import 'package:chat_app/auth/login.dart';
import 'package:chat_app/screens/profile.dart';
import 'package:chat_app/auth/reg.dart';
import 'package:chat_app/screens/location.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterStatusbarcolor.setStatusBarColor(Colors.indigo[900]);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "auth",
      routes: {
        "auth": (context) => Auth(),
        "home": (context) => Home(),
        "reg": (context) => AccountRegistration(),
        "login": (context) => Login(),
        "chat": (context) => Chat(),
        "profile": (context) => Profile(),
        "location": (context) => Location(),
      },
    ),
  );
}