import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'location/locations.dart' as locations;
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }

  Future<void> _addCommunityMarkers() async {
    // Firestore'dan community_requests koleksiyonundan requestStatus değeri true olan toplulukları almak
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('community_requests')
        .where('requestStatus', isEqualTo: true)
        .get();

    // snapshot'taki toplulukların konum bilgilerini kullanarak haritada işaretleme yapmak
    setState(() {
      _markers.clear();
      for (var doc in snapshot.docs) {
        var communityName = doc['communityName'];
        var communityLat = doc['latitude']; // Topluluğun enlem değeri
        var communityLng = doc['longitude']; // Topluluğun boylam değeri

        final marker = Marker(
          markerId: MarkerId(communityName),
          position: LatLng(communityLat, communityLng),
          infoWindow: InfoWindow(
            title: communityName,
            snippet: doc['communityAddress'], // Topluluğun adres bilgisi
          ),
        );
        _markers[communityName] = marker;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _addCommunityMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.pinkAccent,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
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
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(0, 0),
            zoom: 2,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}
