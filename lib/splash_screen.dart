import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'main.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({Key? key}) : super(key: key);

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(seconds: 2),(){
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Publeet",style: TextStyle(color: Colors.white, fontSize: 35),
              ),
              SizedBox(height: 10,),
              Icon(Icons.join_inner)
            ],
          ),
      ),
    );
  }
}
