import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:publeet1/create_announcements.dart';

class AnnounceAdmin extends StatefulWidget {
  const AnnounceAdmin({Key? key}) : super(key: key);

  @override
  State<AnnounceAdmin> createState() => _AnnounceAdminState();
}

class _AnnounceAdminState extends State<AnnounceAdmin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GetData data = GetData();

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;

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
            Text("Topluluk Seç"),
            SizedBox(
              width: 2,
            ),
            Icon(Icons.group),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder<List<String>>(
              stream: data.getData(currentUser!.email.toString()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<String>? communityNames = snapshot.data;
                  if (communityNames != null && communityNames.isNotEmpty) {
                    return ListView.builder(
                      itemCount: communityNames.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                          CreateAnnouncements(communityName: communityNames[index],),));
                                    },
                                    child: Text(
                                      communityNames[index],
                                      style: const TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('community_requests')
                                      .where('communityName', isEqualTo: communityNames[index])
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    return const SizedBox();
                                  },
                                ),
                              ],
                            ),
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
          ),
        ],
      ),
    );
  }
}

class GetData {
  Stream<List<String>> getData(String email) {
    return FirebaseFirestore.instance
        .collection('community_requests')
        .where('userEmail', isEqualTo: email)
        .where('requestStatus', isEqualTo: true)
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
