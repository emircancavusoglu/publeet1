import 'package:flutter/material.dart';

class AnnounceAdmin extends StatefulWidget {
  const AnnounceAdmin({Key? key}) : super(key: key);

  @override
  State<AnnounceAdmin> createState() => _AnnounceAdminState();
}

class _AnnounceAdminState extends State<AnnounceAdmin> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Duyuru Ekle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                hintText: "Duyuru ekleyin...",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String enteredText = _textEditingController.text;
                print("Kullanıcının girdiği metin: $enteredText");
              },
              child: const Text("Gönder"),
            ),
          ],
        ),
      ),
    );
  }
}
