import 'package:flutter/material.dart';
import 'package:publeet1/request_community.dart';
import 'package:publeet1/location/sign_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class AddCommunityForm extends StatefulWidget {
  const AddCommunityForm({Key? key}) : super(key: key);

  @override
  _AddCommunityFormState createState() => _AddCommunityFormState();
}

class _AddCommunityFormState extends State<AddCommunityForm> {
  final _formKey = GlobalKey<FormState>();
  final toplulukAdController = TextEditingController();
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();
  final latitude = KonumKayit.latitude;
  final longitude = KonumKayit.longitude;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  @override
  void dispose() {
    toplulukAdController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
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
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Açıklama",
                        border: UnderlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Lütfen topluluğunuzu tanıtan açıklamayı girin";
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
                        final currentUser = _auth.currentUser;
                        final userEmail = currentUser?.email ?? '';
                        await FirebaseFirestore.instance.collection("community").add({
                          "toplulukIsmi": toplulukAdController.text,
                          "email": _emailController.text,
                          "description": _descriptionController.text,
                          "user_info" : userEmail,
                          "latitude" : KonumKayit.latitude,
                          "longitude" : KonumKayit.longitude
                        });
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          setState(() {
                            _isLoading = false;
                          });

                          final snackBar = ScaffoldMessenger.of(context);
                          snackBar.showSnackBar(
                            const SnackBar(content: Text("Bilgiler kaydedildi")),
                          );
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const RequestCommunity(),));
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
