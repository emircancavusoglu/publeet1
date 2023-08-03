import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
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
  // Kullanıcının mevcut konumunu almak için
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
    // Eğer konum bilgileri alınmadıysa, bir yükleniyor göstergesi göster.
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
              return FutureBuilder<List<Map<String, dynamic>>>(
                future: _getSortedCommunities(communityNames),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    List<Map<String, dynamic>> sortedCommunities = snapshot.data!;
                    return ListView.builder(
                      itemCount: sortedCommunities.length,
                      itemBuilder: (context, index) {
                        String communityName = sortedCommunities[index]["name"];
                        double distance = sortedCommunities[index]["distance"];
                        String? communityAddress = sortedCommunities[index]["address"];
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JoinCommunityDetails(
                                  communityName: communityName,
                                ),
                              ),
                            );
                          },
                          title: Row(
                            children: [
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  communityName,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
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
                          subtitle: Text(communityAddress ?? ""),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('Topluluk bulunamadı.'));
                  }
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

  Future<List<Map<String, dynamic>>> _getSortedCommunities(List<String> communityNames) async {
    List<Map<String, dynamic>> sortedCommunities = [];
    for (String communityName in communityNames) {
      Map<String, double> communityCoordinates = await _getCommunityCoordinates(communityName);
      double distance = _calculateDistance(
        _userLatitude,
        _userLongitude,
        communityCoordinates['latitude'] ?? 0.0,
        communityCoordinates['longitude'] ?? 0.0,
      );
      String? communityAddress = await _getCommunityAddress(communityName);
      sortedCommunities.add({
        "name": communityName,
        "distance": distance,
        "address": communityAddress,
      });
    }
    sortedCommunities.sort((a, b) => a["distance"].compareTo(b["distance"]));
    return sortedCommunities;
  }

  Future<Map<String, double>> _getCommunityCoordinates(String communityName) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final QuerySnapshot snapshot = await firestore
          .collection('community_requests')
          .where('communityName', isEqualTo: communityName)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final DocumentSnapshot documentSnapshot = snapshot.docs.first;
        final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        final double communityLatitude = data['latitude'] as double;
        final double communityLongitude = data['longitude'] as double;
        return {
          'latitude': communityLatitude,
          'longitude': communityLongitude,
        };
      } else {
        return {};
      }
    } catch (e) {
      print('Hata: $e');
      return {};
    }
  }

  Future<String?> _getCommunityAddress(String communityName) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final QuerySnapshot snapshot = await firestore
          .collection('community_requests')
          .where('communityName', isEqualTo: communityName)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final DocumentSnapshot documentSnapshot = snapshot.docs.first;
        final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        final String? communityAddress = data['communityAddress'] as String?;
        return communityAddress;
      } else {
        return null;
      }
    } catch (e) {
      print('Hata: $e');
      return null;
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Dünya yarıçapı (km)
    double lat1Rad = _degToRad(lat1);
    double lon1Rad = _degToRad(lon1);
    double lat2Rad = _degToRad(lat2);
    double lon2Rad = _degToRad(lon2);
    double dLat = lat2Rad - lat1Rad;
    double dLon = lon2Rad - lon1Rad;
    double a = math.pow(math.sin(dLat / 2), 2) + math.cos(lat1Rad) * math.cos(lat2Rad) * math.pow(math.sin(dLon / 2), 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = earthRadius * c;
    return distance;
  }

  double _degToRad(double deg) {
    return deg * (math.pi / 180);
  }
}
