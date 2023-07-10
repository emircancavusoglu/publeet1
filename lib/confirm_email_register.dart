import 'package:flutter/material.dart';
import 'package:publeet1/services/auth_services.dart';
import 'package:publeet1/sign_register_form.dart';

class ConfirmEmailRegister extends StatelessWidget {
  UserRegistrationScreenState register = UserRegistrationScreenState();
  final String email;
  final String password;
  ConfirmEmailRegister(
  {
    required this.email,
    required this.password,
    Key? key,

}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doğrulama Kodu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Mail adresinize gelen doğrulama kodunu giriniz.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Doğrulama Kodu',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                AuthServices().signUp(email: register.emailController.text, password: register.passwordController.text);
              },
              child: const Text('Gönder'),
            ),
          ],
        ),
      ),
    );
  }
}
