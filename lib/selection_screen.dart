import 'package:flutter/material.dart';
import 'package:publeet1/find_community.dart';
import 'my_communities.dart';
import 'communityWorld.dart';
import 'add_community.dart';
import 'login_screen.dart';

class SelectionScreen extends StatelessWidget {
  final TextEditingController toplulukAdController = TextEditingController();

  SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              const Row(
                children: [
                  Row(
                    children: [
                      Text(
                        "Kullanıcı Bilgisi",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.person),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 50),
              const Column(
                children: [
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Kayıtlı Olduğun Topluluklar:",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    "Satranç Topluluğu",
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
              Row(
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
              Row(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.group),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyCommunities(toplulukIsmi:"" ),
                        ),
                      );
                    },
                    child: const Text(
                      "Topluluklarım",
                      style: TextStyle(fontSize: 24, color: Colors.deepPurple),
                    ),
                  ),
                ],
              ),
              Row(
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
            ],
          ),
        ),
      ),
    );
  }
}
