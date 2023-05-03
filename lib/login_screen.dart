import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:publeet1/community_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(hintText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                if(_emailController.text.isNotEmpty&&_passwordController.text.isNotEmpty){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CommunityScreen(),));
                }
                else{
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: const Text("Warning !"),
                      content: const Text("Username or password cannot be left blank"),
                      actions: [
                        TextButton(onPressed: (){
                          Navigator.of(context).pop();
                        }, child: const Text("Ok"))
                      ],
                    );
                  },
                  );
                }
              },
              child: const Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }
}
