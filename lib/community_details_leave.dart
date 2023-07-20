import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:publeet1/request_sent.dart';
import 'location/sign_location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CommunityDetailsLeave extends StatefulWidget {
  final String communityName;

  const CommunityDetailsLeave({Key? key, required this.communityName}) : super(key: key);

  @override
  _CommunityDetailsLeaveState createState() => _CommunityDetailsLeaveState();
}

class _CommunityDetailsLeaveState extends State<CommunityDetailsLeave> {
  String? _currentAddress;
  final communityNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final userAddress = locationProvider.userAddress;
    User? currentUser = _auth.currentUser;

    Future<void> topluluktanAyril() async {
      final userDocRef = FirebaseFirestore.instance.collection("users").doc(currentUser!.uid);

      // Kullanıcının topluluk listesinden çıkarılması için güncelleme
      await userDocRef.update({
        "joinedCommunities": FieldValue.arrayRemove([widget.communityName]),
      });

      // İlgili topluluk isteğinin silinmesi
      await FirebaseFirestore.instance
          .collection('community_requests')
          .where('communityName', isEqualTo: widget.communityName)
          .where('userEmail', isEqualTo: currentUser.email)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });
    Navigator.pop(context);
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
        title: Row(
          children: [
            const SizedBox(width: 26),
            Text("${widget.communityName} Detay"),
            const SizedBox(width: 2),
            const Icon(Icons.group),
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
            List<double> latitudes = [];
            List<double> longitudes = [];

            for (var doc in snapshot.data!.docs) {
              var description = doc.get('description');
              var latitude = doc.get('latitude') as double;
              var longitude = doc.get('longitude') as double;
              descriptions.add(description);
              latitudes.add(latitude);
              longitudes.add(longitude);
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
                    const SizedBox(height: 8),
                    const Text(
                      'Açıklama:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: descriptions.asMap().entries.map((entry) {
                        var index = entry.key;
                        var description = entry.value;
                        var latitude = latitudes[index].toStringAsFixed(6); // Convert double to string with 6 decimal places
                        var longitude = longitudes[index].toStringAsFixed(6); // Convert double to string with 6 decimal places
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              description,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Latitude: $latitude',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Longitude: $longitude',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (userAddress != null && userAddress.isNotEmpty)
                              Text(
                                "Adres: ${userAddress[0].thoroughfare ?? ''} ${userAddress[0].subThoroughfare ?? ''} ${userAddress[0].locality ?? ''} ${userAddress[0].administrativeArea ?? ''} ${userAddress[0].country ?? ''}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            const SizedBox(height: 8),
                            if (latitudes.isNotEmpty && longitudes.isNotEmpty)
                              SizedBox(
                                height: 200,
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(latitudes[0], longitudes[0]),
                                    zoom: 15,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId: MarkerId(widget.communityName),
                                      position: LatLng(latitudes[0], longitudes[0]),
                                    ),
                                  },
                                ),
                              ),
                            const SizedBox(height: 40,),
                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await topluluktanAyril();
                                },
                                child: const Text("Topluluktan Ayrıl"),
                              ),
                            )
                          ],
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
