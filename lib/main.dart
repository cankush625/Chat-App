import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/screens/home.dart';
import 'package:chat_app/screens/login.dart';
import 'package:chat_app/screens/profile.dart';
import 'package:chat_app/screens/reg.dart';
import 'package:chat_app/screens/location.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "home",
      routes: {
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