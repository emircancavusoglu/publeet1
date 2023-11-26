import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateAnnouncements extends StatefulWidget {
  final String communityName;
  CreateAnnouncements({required this.communityName, Key? key}) : super(key: key);

  @override
  State<CreateAnnouncements> createState() => _CreateAnnouncementsState();
}

class _CreateAnnouncementsState extends State<CreateAnnouncements> {
  final TextEditingController _announcementController = TextEditingController();
  int userAnnouncementCount = 0;

  @override
  void dispose() {
    _announcementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Duyuru Oluştur"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Topluluk: ${widget.communityName}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _announcementController,
              maxLines: 5,
              maxLength: 256, // Set the maximum character limit to 256
              maxLengthEnforcement: MaxLengthEnforcement.enforced, // Enforce the maximum limit
              decoration: const InputDecoration(
                labelText: "Duyuru İçeriği",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String announcementText = _announcementController.text.trim();
                if (announcementText.isNotEmpty) {
                  String email = (FirebaseAuth.instance.currentUser)?.email ?? '';
                  // Firestore reference for announcements
                  //change collection
                  CollectionReference announcementsRef = FirebaseFirestore.instance.collection("communities");
                  // Get current user's announcements within the last 24 hours
                  QuerySnapshot userAnnouncements = await announcementsRef
                      .where("userEmail", isEqualTo: email)
                      .where("timeStamp", isGreaterThan: DateTime.now().subtract(const Duration(hours: 24)))
                      .get();
                  userAnnouncementCount = userAnnouncements.docs.length;
                  // Check if the user has made less than 4 announcements within the last 24 hours
                  if (userAnnouncementCount < 10) {
                    // Create a new announcement
                    announcementsRef.add(
                      {
                        "communityName": widget.communityName,
                        "announcement": announcementText,
                        "timeStamp": FieldValue.serverTimestamp(),
                        "userEmail": email,
                      },
                    ).then((value) {
                      Navigator.pop(context);
                      _announcementController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Duyuru başarıyla yayınlandı !"), duration: Duration(seconds: 2)),
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("24 saat içinde en fazla 10 duyuru yapabilirsiniz."), duration: Duration(seconds: 2)),
                    );
                  }
                }
              },
              child: const Text("Duyuruyu Yayınla"),
            ),
          ],
        ),
      ),
    );
  }
}
