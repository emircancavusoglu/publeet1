import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'community_details.dart';
import 'login_screen.dart';

class MyCommunities extends StatefulWidget {
  const MyCommunities({Key? key}) : super(key: key);

  @override
  State<MyCommunities> createState() => _MyCommunitiesState();
}

class _MyCommunitiesState extends State<MyCommunities> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GetData data = GetData();

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      // Kullanıcı oturum açmamışsa giriş ekranına yönlendir
      return const LoginScreen();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Row(
          children: [
            SizedBox(
              width: 26,
            ),
            Text("Topluluklarım"),
            SizedBox(
              width: 4,
            ),
            Icon(Icons.group),
          ],
        ),
      ),
      body: StreamBuilder<List<String>>(
        stream: data.getData(currentUser.email.toString()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String>? communityNames = snapshot.data;
            if (communityNames != null && communityNames.isNotEmpty) {
              return ListView.builder(
                itemCount: communityNames.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CommunityDetails()),
                        );
                      },
                      child: Text(communityNames[index]),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text(
                  'Topluluk bulunamadı.',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }
          } else if (snapshot.hasError) {
            return Text('Hata: ${snapshot.error}');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
class GetData {
  Stream<List<String>> getData(String email) {
    return FirebaseFirestore.instance
        .collection('community_requests')
        .where('userEmail', isEqualTo: email)
        .snapshots()
        .map((snapshot) {
      List<String> communityNames = [];
      for (var doc in snapshot.docs) {
        var communityName = doc['communityName'];
        communityNames.add(communityName);
      }
      return communityNames;
    });
  }
}

