import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:publeet1/request_community.dart';
import 'package:publeet1/location/sign_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:publeet1/selection_screen.dart';
import 'package:publeet1/style.dart';

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
                        color: MainColor.mainColor,
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
                    IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const KonumKayit(),));
                    }, icon: const Icon(Icons.add_location_alt)),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(
                          MainColor.mainColor)),
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
                          bool isCommunityNameExists = await _isCommunityNameExists(communityNameController.text);
                          if (isCommunityNameExists) {
                            final snackBar = const SnackBar(content: Text("Bu isimde bir topluluk zaten mevcut!"));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            return;
                          }
                          await FirebaseFirestore.instance.collection("community_requests").add({
                            "communityName": communityNameController.text,
                            "description": _descriptionController.text,
                            "userEmail": userEmail,
                            "latitude": userPosition.latitude,
                            "longitude": userPosition.longitude,
                            "communityAddress": _currentAddress,
                            "requestStatus": false,
                          });
                          const snackBar = SnackBar(content: Text("Bilgiler kaydedildi"));
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
                  color: MainColor.mainColor,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _isCommunityNameExists(String communityName) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final QuerySnapshot snapshot = await firestore
          .collection('community_requests')
          .where('communityName', isEqualTo: communityName)
          .limit(1)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Hata: $e');
      return false;
    }
  }
}
