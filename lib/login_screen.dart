import 'package:flutter/material.dart';
import 'package:publeet1/selection_screen.dart';
import 'package:publeet1/utilities/facebook_sign_in.dart';
import 'package:publeet1/utilities/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  void toSelectionScreen(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  SelectionScreen(),));
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
                  print('Google Sign-In Error: $error');
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
                    'assets/google.png',
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
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Handle Apple login here
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(300, 60),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.apple,
                    color: Colors.grey,
                    size: 30,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Apple ile Giriş Yap',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async{
                await signInWithFacebook();
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
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.facebook,
                    color: Colors.blue,
                    size: 30,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Facebook ile Giriş Yap',
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
}
