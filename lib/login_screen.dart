import 'package:flutter/material.dart';
import 'package:publeet1/selection_screen.dart';
import 'package:publeet1/utilities/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  void toSelectionScreen(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const SelectionScreen(),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Publeet",
              style: TextStyle(
                color: Colors.indigoAccent,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () async {
                try {
                  await signInWithGoogle();
                  toSelectionScreen();
                } catch (error) {
                  Text("$error");
                }
                toSelectionScreen();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(300, 60),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    assetGoogle(),
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Google ile Giriş Yap',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  String assetGoogle() => 'assets/google.png';
}
