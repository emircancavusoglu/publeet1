import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class FindCommunity extends StatefulWidget {
  @override
  _FindCommunityState createState() => _FindCommunityState();
}

class _FindCommunityState extends State<FindCommunity> {
  Position? _currentPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Topluluk Bul',style: TextStyle(fontWeight:FontWeight.bold),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_currentPosition != null)
              Text(
                  'Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}'),
            ElevatedButton(
              onPressed: () async {
                LocationPermission permission =
                await Geolocator.requestPermission();

                if (permission == LocationPermission.denied ||
                    permission == LocationPermission.deniedForever) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Konum izni verilmedi. Ayarlardan izin vermeniz gerekiyor.'),
                    ),
                  );
                  return;
                }

                Position position =
                await Geolocator.getCurrentPosition();
                setState(() {
                  _currentPosition = position;
                });
              },
              child: const Text('Konum İzni Al'),
            ),
          ],
        ),
      ),
    );
  }
}
