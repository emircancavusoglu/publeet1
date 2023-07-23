import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:publeet1/announcements.dart';
import 'package:publeet1/announcements_admin.dart';
import 'package:publeet1/find_community.dart';
import 'package:publeet1/login_screen.dart';
import 'package:publeet1/my_notifications.dart';
import 'package:publeet1/utilities/google_sign_in.dart';
import 'package:publeet1/my_communities.dart';
import 'communityWorld.dart';
import 'add_community.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'community_details_leave.dart';

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
  void navigateToCommunityDetailsLeave(String communityName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommunityDetailsLeave(communityName: communityName),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    Stream<List<String>> userCommunitiesStream = getData(currentUser?.uid ?? '');
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hoşgeldin"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Publeet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.announcement),
              title: const Text('Duyurular'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Announc(),));
              },
            ),
            ListTile(
              leading: const Icon(Icons.announcement_outlined),
              title: const Text('Duyurularım'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AnnounceAdmin(),));
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Column(
                children: [
                  const Text(
                    "Kayıtlı Olduğun Topluluklar:",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  StreamBuilder<List<String>>(
                    stream: userCommunitiesStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final List<String> userCommunities = snapshot.data ?? [];
                        return SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: userCommunities.length,
                            itemBuilder: (context, index) {
                              final communityName = userCommunities[index];
                              return GestureDetector(
                                onTap: () => navigateToCommunityDetailsLeave(communityName),
                                child: Text(
                                  communityName,
                                  style: const TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return const Text(
                          'Topluluklar Yükleniyor...',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 45),
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
                            builder: (context) => const CommunityWorld(),
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
        color: Colors.white,
        child: TextButton(
          onPressed: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.deepPurple),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.deepPurple,
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
Stream<List<String>> getData(String id) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(id)
      .snapshots()
      .map((snapshot) {
    if (snapshot.exists) {
      var communityNames = snapshot['joinedCommunities'];
      return List<String>.from(communityNames ?? []);
    } else {
      return [];
    }
  });
}
