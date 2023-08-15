import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:publeet1/style.dart';
import 'add_community.dart';
import 'announcements.dart';
import 'announcements_admin.dart';
import 'communityWorld.dart';
import 'community_details_leave.dart';
import 'find_community.dart';
import 'login_screen.dart';
import 'package:publeet1/my_communities.dart' as myCommunities;
import 'my_communities.dart';
import 'my_notifications.dart';
import 'utilities/google_sign_in.dart';

class SelectionScreen extends StatefulWidget {
  SelectionScreen({Key? key}) : super(key: key);

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  final TextEditingController toplulukAdController = TextEditingController();

  late User? currentUser;
  late Stream<List<String>> userCommunitiesStream;
  late Stream<List<String>> myCommunitiesStream;
  late String name;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    userCommunitiesStream = getData(currentUser?.uid ?? '');
    myCommunitiesStream = myCommunities.GetData().getData(currentUser?.email.toString() ?? '');
    name = currentUser?.displayName ?? '';
  }

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
    return Scaffold(
      appBar: AppBar(
        title: SingleChildScrollView(
          child: Text("Hoşgeldin $name"),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: MainColor.mainColor,
              ),
              child: Center(
                child: Text(
                  'Publeet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Size.fontSize,
                  ),
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
              title: const Text('Duyuru Ekle'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AnnounceAdmin(),));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Column(
              children: [
                const Text(
                  "Kayıtlı Olduğun Topluluklar:",
                  style: TextStyle(
                    color: MainColor.mainColor,
                    fontSize: Size.fontSize,
                    fontWeight: FontW.fontw,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
                StreamBuilder<List<String>>(
                  stream: userCommunitiesStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final List<String> userCommunities = snapshot.data ?? [];
                      return Column(
                        children: [
                          ...userCommunities.map((communityName) {
                            return GestureDetector(
                              onTap: () => navigateToCommunityDetailsLeave(communityName),
                              child: TextWidget(textName: communityName),
                            );
                          }),
                          StreamBuilder<List<String>>(
                            stream: myCommunitiesStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final List<String> myCommunities = snapshot.data ?? [];
                                final nonDuplicateCommunities = myCommunities.where((community) => !userCommunities.contains(community)).toList();
                                return Column(
                                  children: nonDuplicateCommunities.map((communityName) {
                                    return GestureDetector(
                                      onTap: () => navigateToCommunityDetailsLeave(communityName),
                                      child: TextWidget(textName: communityName),
                                    );
                                  }).toList(),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  'Hata: ${snapshot.error}',
                                  style: const TextStyle(
                                    color: MainColor.mainColor,
                                    fontSize: Size.fontSize,
                                    fontWeight: FontW.fontw,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              } else {
                                return const TextWidget(
                                    textName: 'Topluluklar Yükleniyor... ');
                              }
                            },
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        'Hata: ${snapshot.error}',
                        style: const TextStyle(
                          color: MainColor.mainColor,
                          fontSize: Size.fontSize,
                          fontWeight: FontW.fontw,
                        ),
                        textAlign: TextAlign.center,
                      );
                    } else {
                      return const TextWidget(textName: 'Topluluklar Yükleniyor... ',);
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
                          builder: (context) => const myCommunities.MyCommunities(),
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
    );
  }
}

class TextWidget extends StatelessWidget {
  final String textName;
  const TextWidget({
    super.key, required this.textName,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "$textName",
      style: const TextStyle(
        color: MainColor.mainColor,
        fontSize: Size.fontSize,
        fontWeight: FontW.fontw,
      ),
      textAlign: TextAlign.center,
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
              Icon(icon, color: MainColor.mainColor),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: Size.fontSize,
                    color: MainColor.mainColor,
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
