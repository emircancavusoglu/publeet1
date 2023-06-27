import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:publeet1/splash_screen.dart';
import 'initialize/app_initialize.dart';


void main() async {
  await ApplicationInitialize.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Publeet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const splash_screen(),
    );
  }
}
