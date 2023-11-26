import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:publeet1/community_details.dart';
import 'package:publeet1/community_list.dart'; // Bu sayfanın importını eklemeyi unutmayın

class CommunityWorld extends StatefulWidget {
  const CommunityWorld({Key? key}) : super(key: key);

  @override
  State<CommunityWorld> createState() => _CommunityWorldState();
}

class _CommunityWorldState extends State<CommunityWorld> {
  final Map<MarkerId, Marker> _markers = {};

  Future<void> _addCommunityMarkers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('community_requests')
        .where('requestStatus', isEqualTo: true)
        .get();

    setState(() {
      _markers.clear();
      var coordinatesMap = <String, int>{};
      for (var doc in snapshot.docs) {
        var communityName = doc['communityName'];
        var communityLat = doc['latitude'];
        var communityLng = doc['longitude'];
        var communityAddress = doc['communityAddress'];
        var communityDocumentId = doc.id;

        String key = '$communityLat-$communityLng';
        int count = coordinatesMap.containsKey(key) ? coordinatesMap[key]! + 1 : 1;
        coordinatesMap[key] = count;

        if (count > 1) {
          key = '$key-$count';
        }

        final markerId = MarkerId(key);

        final marker = Marker(
          markerId: markerId,
          position: LatLng(communityLat, communityLng),
          infoWindow: InfoWindow(
            title: communityName,
            snippet: communityAddress,
            onTap: () => _onInfoWindowTapped(markerId),
          ),
        );
        _markers[markerId] = marker;
      }
    });
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

  void _onInfoWindowTapped(MarkerId markerId) {
    final tappedMarker = _markers[markerId];
    if (tappedMarker != null) {
      _navigateToCommunityDetails(tappedMarker.infoWindow.title ?? '');
    }
  }

  void _navigateToCommunityDetails(String communityName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CommunityList()),
    );
  }
}
