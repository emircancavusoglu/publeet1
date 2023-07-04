import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:publeet1/find_community.dart';
import 'package:publeet1/login_screen.dart';
import 'my_communities.dart';
import 'communityWorld.dart';
import 'add_community.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SelectionScreen extends StatefulWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  final TextEditingController toplulukAdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Column(
                children: [
                  Text(
                    "Kayıtlı Olduğun Topluluklar:",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "",
                    style: TextStyle(
                      color: Colors.brown,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 100),
              Card(
                color: Colors.white70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.group_add_outlined, color: Colors.black),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddCommunityForm(),
                          ),
                        );
                      },
                      child: const Text(
                        "Topluluk Ekle",
                        style: TextStyle(fontSize: 24, color: Colors.deepPurple),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                color: Colors.white70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FindCommunity(),
                          ),
                        );
                      },
                      child: const Text(
                        "Topluluk Bul",
                        style: TextStyle(fontSize: 24, color: Colors.deepPurple),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                color: Colors.white70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.group),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MyCommunities(),));
                        getData();
                      },
                      child: const Text(
                        "Topluluklarım",
                        style: TextStyle(fontSize: 24, color: Colors.deepPurple),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                color: Colors.white70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.public),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CommunityScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Dünyadaki Topluluklar",
                        style: TextStyle(fontSize: 24, color: Colors.deepPurple),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                icon: const Icon(Icons.logout_outlined),
                label: const Text("Çıkış Yap"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
void getData(){
  FirebaseFirestore.instance
      .collection('community')
      .doc('OIJA9fZW5iXwr8qvxnc0')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      var communityName = documentSnapshot['communityName'];
      print('communityName: $communityName');
    } else {
      print('Document does not exist in the database');
    }
  });
}