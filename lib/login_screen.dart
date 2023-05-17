import 'package:publeet1/selection_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Publeet",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.indigoAccent
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: userNameController,
              decoration: InputDecoration(
                hintText: 'Kullanıcı adı',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: 'Şifre',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                if(userNameController.text.isNotEmpty&&passwordController.text.isNotEmpty){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  SelectionScreen(userName: userNameController.text),));
                }
                else{
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: const Text("Uyarı !"),
                      content: const Text("Kullanıcı adı veya şifre boş geçilemez"),
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
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Giriş Yap'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {},
              child: const Text(
                "Şifreni mi unuttun ?",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Hesabın yok mu ?",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Kayıt ol.",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
