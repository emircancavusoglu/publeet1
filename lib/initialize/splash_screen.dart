import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:publeet1/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    Timer(const Duration(seconds: 2),
    ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
    const LoginScreen(),)));
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
          height: double.infinity,
          child: Image.asset('assets/publeet1.png',fit: BoxFit.cover,)),
    );
  }
}
