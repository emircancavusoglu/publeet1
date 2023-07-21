import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
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
  String? _currentAddress;
  final _formKey = GlobalKey<FormState>();
  final communityNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  @override
  void dispose() {
    communityNameController.dispose();
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
                    const Align(
                      alignment: Alignment.topCenter,
                      child: Icon(
                        Icons.sentiment_satisfied_alt,
                        size: 96,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      controller: communityNameController,
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
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepPurple)),
                      onPressed: () async {
                        final currentUser = _auth.currentUser;
                        final userEmail = currentUser?.email ?? '';
                        final userPosition = Provider.of<LocationProvider>(context, listen: false).userPosition;
                        if (_formKey.currentState!.validate() && userPosition != null) {
                          final List<Placemark> placemarks = await placemarkFromCoordinates(
                            userPosition.latitude,
                            userPosition.longitude,
                          );
                          if (placemarks.isNotEmpty) {
                            Placemark place = placemarks[0];
                            _currentAddress = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
                          }
                          await FirebaseFirestore.instance.collection("community").doc(userEmail).set({
                            "communityName": communityNameController.text,
                          });
                          await FirebaseFirestore.instance.collection("community_requests").add({
                            "communityName": communityNameController.text,
                            "description": _descriptionController.text,
                            "userEmail": userEmail,
                            "latitude": userPosition.latitude,
                            "longitude": userPosition.longitude,
                            "communityAddress": _currentAddress,
                            "requestStatus": false,
                          });
                          final snackBar = const SnackBar(content: Text("Bilgiler kaydedildi"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const RequestCommunity()));
                        } else {
                          final snackBar = SnackBar(content: const Text("Konum bilgisi alınamadı veya formda eksik bilgi var!"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: const Text("Kaydet"),
                    ),
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
