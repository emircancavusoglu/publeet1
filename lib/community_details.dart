import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:publeet1/community_details.dart';

class CommunityDetails extends StatefulWidget {
  const CommunityDetails({Key? key}) : super(key: key);

  @override
  State<CommunityDetails> createState() => _CommunityDetailsState();
}

class _CommunityDetailsState extends State<CommunityDetails> {
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
            Text("Topluluklarım Detay"),
            SizedBox(
              width: 2,
            ),
            Icon(Icons.group),
          ],
        ),
      ),
      body: StreamBuilder<List<String>>(
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
                              onPressed: (){},
                              child: Text(communityNames[index][0],
                                style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),),
                            ),
                          ),
                          const SizedBox(height: 2),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('community_requests')
                                .where('communityName', isEqualTo: communityNames[index])
                                .where('requestStatus', isEqualTo: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                                List<String> descriptions = [];

                                for (var doc in snapshot.data!.docs) {
                                  var description = doc.get('description');
                                  descriptions.add(description);
                                }

                                var requestStatus = snapshot.data!.docs[0].get('requestStatus');

                                if (requestStatus == true) {
                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Durum: ${requestStatus ?? "Hata"}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: requestStatus == 'Beklemede' ? Colors.orange : Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        const Text(
                                          'Tanımlar:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: descriptions.map((description) {
                                            return Text(
                                              description ?? 'Hata',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              } else if (snapshot.hasError) {
                                return Text('Hata: ${snapshot.error}');
                              }
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
