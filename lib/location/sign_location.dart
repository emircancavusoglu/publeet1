import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const KonumKayit());
}

class KonumKayit extends StatefulWidget {
  static double? latitude;
  static double? longitude;

  const KonumKayit({Key? key}) : super(key: key);

  @override
  State<KonumKayit> createState() => _KonumKayitState();
}

class _KonumKayitState extends State<KonumKayit> {
  final Gps _gps = Gps();
  Position? _userPosition;
  List<Placemark>? _userAddress;
  Exception? _exception;
  bool _showDialog = false;

  @override
  void initState() {
    super.initState();
    _gps.startPositionStream(_handlePositionStream).catchError((e) {
      setState(() {
        _exception = e as Exception?;
        _showDialog = true;
      });
    });
  }

  void _handlePositionStream(Position position) async {
    setState(() {
      _userPosition = position;
    });

    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        KonumKayit.latitude = _userPosition!.latitude,
        KonumKayit.longitude = _userPosition!.longitude,
      );
      if (placemarks.isNotEmpty) {
        setState(() {
          _userAddress = placemarks;
          _showDialog = true;
        });
      }
    } catch (e) {
      setState(() {
        _exception = e as Exception?;
        _showDialog = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_exception != null) {
      child = const Text("Lütfen gps'e izin veriniz.");
    } else if (_userPosition == null) {
      child = const CircularProgressIndicator();
    } else {
      final latitude = _userPosition!.latitude;
      final longitude = _userPosition!.longitude;
      final location = "Enlem: $latitude\nBoylam: $longitude";

      String address = '';
      if (_userAddress != null && _userAddress!.isNotEmpty) {
        final placemark = _userAddress![0];
        address = placemark.thoroughfare ?? '';
        if (placemark.subThoroughfare != null) {
          address += ', ${placemark.subThoroughfare}';
        }
        if (placemark.locality != null) {
          address += ', ${placemark.locality}';
        }
        if (placemark.administrativeArea != null) {
          address += ', ${placemark.administrativeArea}';
        }
        if (placemark.country != null) {
          address += ', ${placemark.country}';
        }
      }
      child = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("location"), //normalde string değil
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
            ),
            onPressed: () {
              setState(() {
                _showDialog = true;
              });
            },
            child: const Text('Kayıt Ol'),
          ),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            child,
            if (_showDialog)
              AlertDialog(
                title: const Text('Adres Bilgisi'),
                content: _userAddress != null && _userAddress!.isNotEmpty
                    ? Text('Adresiniz: ${_userAddress![0]}')
                    : const Text('Adres bilgisi bulunamadı.'),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {

                      Navigator.pop(context);
                      setState(() {
                        _showDialog = false;
                      });
                    },
                    child: const Text('Reddet'),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _showDialog = false;
                      });
                    },
                    child: const Text('Onaylıyorum'),
                  ),

                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _gps.StopPositionStream();
  }
}

class Gps {
  late StreamSubscription<Position> _positionStream;

  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (isAccessGranted(permission)) {
      return true;
    }
    permission = await Geolocator.requestPermission();
    return isAccessGranted(permission);
  }

  bool isAccessGranted(LocationPermission permission) {
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<void> startPositionStream(Function(Position position) callback) async {
    bool permissionGranted = await requestPermission();
    if (!permissionGranted) {
      throw Exception("Kullanıcı Gps iznini vermedi.");
    }
    _positionStream = Geolocator.getPositionStream().listen(callback);
  }

  void StopPositionStream() {
    _positionStream.cancel();
  }
}