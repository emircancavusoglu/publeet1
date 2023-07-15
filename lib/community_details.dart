import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommunityDetails extends StatefulWidget {
  final String communityName;

  const CommunityDetails({Key? key, required this.communityName}) : super(key: key);

  @override
  _CommunityDetailsState createState() => _CommunityDetailsState();
}

class _CommunityDetailsState extends State<CommunityDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
            SizedBox(width: 26),
            Text("Topluluklarım"),
            SizedBox(width: 2),
            Icon(Icons.group),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('community_requests')
            .where('communityName', isEqualTo: widget.communityName)
            .where('userEmail', isEqualTo: currentUser!.email)
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
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.communityName,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Durum: ${requestStatus ?? "Hata"}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: requestStatus == 'Beklemede' ? Colors.orange : Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
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
    );
  }
}
