import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Announc extends StatefulWidget {
  const Announc({Key? key}) : super(key: key);

  @override
  State<Announc> createState() => _AnnouncState();
}

class _AnnouncState extends State<Announc> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Duyurular")),
      body: StreamBuilder<List<String>>(
        stream: getData(currentUser?.uid ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            final List<String> userCommunities = snapshot.data ?? [];
            return StreamBuilder<QuerySnapshot>(
              stream: _getAnnouncements(userCommunities),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  final List<QueryDocumentSnapshot>? announcements = snapshot.data?.docs;
                  if (announcements != null) {
                    return SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: announcements.length,
                        itemBuilder: (context, index) {
                          final announcement = announcements[index];
                          final data = announcement.data() as Map<String, dynamic>; // Veri haritasını Map<String, dynamic> türüne dönüştürün
                          final String communityName = data['communityName'] ?? '';
                          final String announcementText = data['announcement'] ?? '';
                          final Timestamp timestamp = data['timeStamp'] ?? Timestamp.fromDate(DateTime(1));

                          final formattedDate = "${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year} ${timestamp.toDate().hour}:${timestamp.toDate().minute}";

                          return ListTile(
                            title: Text(communityName),
                            subtitle: Text(announcementText),
                            trailing: Text(formattedDate),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Text("Duyuru yok");
                  }
                } else {
                  return const Text("Duyuru yok");
                }
              },
            );
          } else {
            return const Text("Topluluklar Yükleniyor...");
          }
        },
      ),
    );
  }

  Stream<QuerySnapshot> _getAnnouncements(List<String> userCommunities) {
    return FirebaseFirestore.instance
        .collection("community_requests")
        .where("communityName", whereIn: userCommunities)
        .snapshots();
  }

  Stream<List<String>> getData(String? id) {
    if (id == null) return Stream.value([]);
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
}
