import 'package:cloud_firestore/cloud_firestore.dart';

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
