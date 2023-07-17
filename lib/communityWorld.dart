import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final Map<String, Marker> _markers = {};

  Future<void> _addCommunityMarkers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('community_requests')
        .where('requestStatus', isEqualTo: true)
        .get();

    setState(() {
      _markers.clear();
      for (var doc in snapshot.docs) {
        var communityName = doc['communityName'];
        var communityLat = doc['latitude'];
        var communityLng = doc['longitude'];
        var communityAddress = doc['communityAddress'];

        final marker = Marker(
          markerId: MarkerId(communityName),
          position: LatLng(communityLat, communityLng),
          infoWindow: InfoWindow(
            title: communityName,
            snippet: communityAddress,
          ),
        );
        _markers[communityName] = marker;
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
}
