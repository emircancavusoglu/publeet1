import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyCommunities extends StatefulWidget {
  const MyCommunities({Key? key}) : super(key: key);

  @override
  State<MyCommunities> createState() => _MyCommunitiesState();
}

class _MyCommunitiesState extends State<MyCommunities> {
  final Map<MarkerId, Marker> _markers = {};

  Future<void> _addCommunityMarkers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('community_requests')
        .where('requestStatus', isEqualTo: true)
        .get();

    setState(() {
      _markers.clear();
      var communityCoordinatesMap = <String, LatLng>{};
      for (var doc in snapshot.docs) {
        var communityName = doc['communityName'];
        var communityLat = doc['latitude'];
        var communityLng = doc['longitude'];
        var communityAddress = doc['communityAddress'];
        var communityDocumentId = doc.id;

        var adjustedCoordinates = _getAdjustedCoordinates(communityCoordinatesMap, communityLat, communityLng);

        String markerIdValue = '$communityName-${adjustedCoordinates.latitude}-${adjustedCoordinates.longitude}-$communityDocumentId';
        final markerId = MarkerId(markerIdValue);

        final marker = Marker(
          markerId: markerId,
          position: adjustedCoordinates,
          infoWindow: InfoWindow(
            title: communityName,
            snippet: communityAddress,
          ),
        );
        _markers[markerId] = marker;
        communityCoordinatesMap[communityName] = adjustedCoordinates;
      }
    });
  }

  LatLng _getAdjustedCoordinates(Map<String, LatLng> coordinatesMap, double lat, double lng) {
    const double increment = 0.0001;
    int attempt = 0;
    String key = '$lat-$lng';
    while (coordinatesMap.containsKey(key)) {
      double newLat = lat + (increment * attempt);
      double newLng = lng + (increment * attempt);
      key = '$newLat-$newLng';
      attempt++;
    }
    return LatLng(lat + (increment * attempt), lng + (increment * attempt));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _addCommunityMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.pinkAccent,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue[700],
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Dünyadaki Topluluklar'),
          elevation: 2,
        ),
        body: GoogleMap(
          onMapCreated: (controller) => _onMapCreated(controller),
          initialCameraPosition: const CameraPosition(
            target: LatLng(0, 0),
            zoom: 2,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    // Harita oluşturulduğunda işlem yapmak için boş bir fonksiyon
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
