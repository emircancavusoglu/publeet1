import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:publeet1/find_community.dart';
import 'package:publeet1/login_screen.dart';
import 'package:publeet1/my_notifications.dart';
import 'package:publeet1/utilities/google_sign_in.dart';
import 'package:publeet1/my_communities.dart';
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

  void toLoginScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

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
                      color: Colors.deepPurple,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: BubbleWidget(
                      icon: Icons.group_add_outlined,
                      text: "Topluluk Ekle",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddCommunityForm(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: BubbleWidget(
                      icon: Icons.search,
                      text: "Topluluk Bul",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FindCommunity(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: BubbleWidget(
                      icon: Icons.public,
                      text: "Keşfet",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CommunityScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: BubbleWidget(
                      icon: Icons.group,
                      text: "Topluluklarım",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyCommunities(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
              const SizedBox(height: 5),
              BubbleWidget(
                icon: Icons.notifications,
                text: "İsteklerim",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyNotifications(),
                    ),
                  );
                },
                width: 160,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () async {
                  await signOutWithGoogle();
                  toLoginScreen();
                },
                icon: const Icon(Icons.logout_outlined),
                label: const Text("Çıkış Yap"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BubbleWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final double width;

  const BubbleWidget({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.width = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: width,
        height: 120,
        color: Colors.deepPurple,
        child: TextButton(
          onPressed: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Stream<List<String>> getData(String email) {
  return FirebaseFirestore.instance
      .collection('community_requests')
      .doc(email)
      .snapshots()
      .map((snapshot) {
    if (snapshot.exists) {
      var communityName = snapshot['communityName'];
      return List<String>.from(communityName ?? []);
    } else {
      return [];
    }
  });
}
