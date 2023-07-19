import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:publeet1/community_details.dart';
import 'package:publeet1/join_community_details.dart';
import 'dart:math' as math;

import 'my_communities.dart';

class CommunityList extends StatefulWidget {
  final String? address;

  const CommunityList({Key? key, this.address}) : super(key: key);

  @override
  _CommunityListState createState() => _CommunityListState();
}

class _CommunityListState extends State<CommunityList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GetData data = GetData();
  double _userLatitude = 0.0; // Kullanıcının enlem değeri
  double _userLongitude = 0.0; // Kullanıcının boylam değeri

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _userLatitude = position.latitude;
        _userLongitude = position.longitude;
      });
    } catch (e) {
      print("Konum alınamadı: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Eğer konum bilgileri alınmadıysa, bir yükleniyor göstergesi gösterelim.
    if (_userLatitude == 0.0 || _userLongitude == 0.0) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text("Topluluk Listesi"),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    User? currentUser = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Topluluk Listesi"),
      ),
      body: StreamBuilder<List<String>>(
        stream: data.getData(currentUser!.email.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            List<String>? communityNames = snapshot.data;
            if (communityNames != null && communityNames.isNotEmpty) {
              // Konum bilgilerini alarak sıralama yapalım
              List<Map<String, dynamic>> sortedCommunities = [];
              for (String communityName in communityNames) {
                double distance = calculateDistance(
                  _userLatitude,
                  _userLongitude,
                  0.0, // Diğer konumun enlem değeri com. details sayfasından al.
                  0.0, // Diğer konumun boylam değeri
                );

                sortedCommunities.add({
                  "name": communityName,
                  "distance": distance,
                });
              }

              // Konuma göre sıralama yapalım
              sortedCommunities.sort((a, b) => a["distance"].compareTo(b["distance"]));

              return ListView.builder(
                itemCount: sortedCommunities.length,
                itemBuilder: (context, index) {
                  String communityName = sortedCommunities[index]["name"];
                  double distance = sortedCommunities[index]["distance"];

                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JoinCommunityDetails(communityName: communityName),
                        ),
                      );
                    },
                    title: Row(
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          communityName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${distance.toStringAsFixed(1)} km uzaklıkta",
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Icon(Icons.stars_outlined),
                      ],
                    ),
                    subtitle: Text(widget.address ?? ""),
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

  Future<String> getRandomCommunityName(int randomIndex) async {
    var collectionRef = FirebaseFirestore.instance.collection('community_requests');
    var snapshot = await collectionRef.get();
    if (snapshot.docs.isEmpty) {
      return "";
    }

    var communityNames = snapshot.docs.map((doc) => doc.get('communityName').toString()).toList();
    var communityName = communityNames[randomIndex];
    return communityName;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Dünya yarıçapı (km)

    // Radyan cinsinden enlem ve boylam değerlerine dönüştürme
    double lat1Rad = degToRad(lat1);
    double lon1Rad = degToRad(lon1);
    double lat2Rad = degToRad(lat2);
    double lon2Rad = degToRad(lon2);

    // Haversine formülü kullanılarak iki nokta arasındaki mesafeyi hesaplama
    double dLat = lat2Rad - lat1Rad;
    double dLon = lon2Rad - lon1Rad;
    double a = math.pow(math.sin(dLat / 2), 2) + math.cos(lat1Rad) * math.cos(lat2Rad) * math.pow(math.sin(dLon / 2), 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }

  double degToRad(double deg) {
    return deg * (math.pi / 180);
  }
}
