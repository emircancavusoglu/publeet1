import 'package:flutter/material.dart';
import 'package:publeet1/my_communities.dart';
import 'package:publeet1/sign_location.dart';

class AddCommunityForm extends StatefulWidget {
  const AddCommunityForm({Key? key}) : super(key: key);

  @override
  _AddCommunityFormState createState() => _AddCommunityFormState();
}

class _AddCommunityFormState extends State<AddCommunityForm> {
  final _formKey = GlobalKey<FormState>();
  final toplulukAdController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonController = TextEditingController();

  String _toplulukIsmi = "";
  bool _isLoading = false;

  @override
  void dispose() {
    toplulukAdController.dispose();
    _emailController.dispose();
    _telefonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Topluluk Ekle"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    const Align(
                      alignment: Alignment.topCenter,
                      child: Icon(
                        Icons.sentiment_satisfied_alt,
                        size: 96,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 12,),
                    TextFormField(
                      controller: toplulukAdController,
                      decoration: const InputDecoration(
                        labelText: "Topluluk İsmi",
                        border: UnderlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Lütfen topluluk ismini giriniz!";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _toplulukIsmi = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "E-posta",
                        border: UnderlineInputBorder(),
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
                        border: UnderlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Lütfen telefon numaranızı girin";
                        }
                        return null;
                      },
                    ),
                    IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const KonumKayit(),));
                      },
                      icon: const Icon(Icons.add_location_alt),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepPurple)),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          await Future.delayed(const Duration(seconds: 1));

                          setState(() {
                            _isLoading = false;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Bilgiler kaydedildi")),
                          );

                          Future.delayed(const Duration(seconds: 1), () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MyCommunities(toplulukIsmi: toplulukAdController.text )));
                          });
                        }
                      },
                      child: const Text("Kaydet"),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              if (_isLoading)
                const CircularProgressIndicator(
                  color: Colors.deepPurple,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
