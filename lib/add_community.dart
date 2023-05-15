import 'package:flutter/material.dart';

class AddCommunityForm extends StatefulWidget {
  const AddCommunityForm({Key? key}) : super(key: key);

  @override
  _AddCommunityFormState createState() => _AddCommunityFormState();
}

class _AddCommunityFormState extends State<AddCommunityForm> {
  final _formKey = GlobalKey<FormState>();
  final _adSoyadController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonController = TextEditingController();

  @override
  void dispose() {
    _adSoyadController.dispose();
    _emailController.dispose();
    _telefonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Topluluk Ekle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _adSoyadController,
                decoration: const InputDecoration(
                  labelText: "Ad Soyad",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Lütfen adınızı ve soyadınızı girin";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "E-posta",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Lütfen e-posta adresinizi girin";
                  }
                  if (!value.contains("@")) {
                    return "Geçersiz e-posta adresi";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefonController,
                decoration: const InputDecoration(
                  labelText: "Telefon",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Lütfen telefon numaranızı girin";
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form geçerliyse burada kaydetme işlemini yapabilirsiniz.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Bilgiler kaydedildi")),
                    );
                  }
                },
                child: const Text("Kaydet"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
