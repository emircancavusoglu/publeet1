import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:publeet1/community_details.dart';

class CommunityList extends StatelessWidget {
  final String? address;

  const CommunityList({Key? key, this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Topluluk Listesi"),
      ),
      body: ListView(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CommunityDetails()),
              );
            },
            child: FutureBuilder(
              future: getRandomCommunityName(0),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  return ListTile(
                    title: Row(
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          snapshot.data.toString().toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "8 km uzaklıkta",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Icon(Icons.stars_outlined),
                      ],
                    ),
                    subtitle: Text(address ?? ""),
                  );
                }
                return const Text("Error");
              },
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CommunityDetails()),
              );
            },
            child: FutureBuilder(
              future: getRandomCommunityName(1),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  return ListTile(
                    title: Row(
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          snapshot.data.toString().toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "8 km uzaklıkta",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Icon(Icons.stars_outlined),
                      ],
                    ),
                    subtitle: Text(address ?? ""),
                  );
                }
                return const Text("Error");
              },
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CommunityDetails()),
              );
            },
            child: FutureBuilder(
              future: getRandomCommunityName(2),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  return ListTile(
                    title: Row(
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          snapshot.data.toString().toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "15 km uzaklıkta",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Icon(Icons.stars_outlined),
                      ],
                    ),
                    subtitle: Text(address ?? ""),
                  );
                }
                return const Text("Error");
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getRandomCommunityName(int randomIndex) async {
    var collectionRef = FirebaseFirestore.instance.collection('community');
    var snapshot = await collectionRef.get();
    if (snapshot.docs.isEmpty) {
      return "";
    }

    var randomDoc = snapshot.docs.elementAt(randomIndex); // Belirli bir indeksteki belgeye erişim
    var communityName = randomDoc.get('communityName');
    return communityName.toString();
  }
}
