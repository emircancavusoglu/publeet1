import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:publeet1/request_community.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocationProvider(),
      child: const KonumKayit(),
    ),
  );
}

class KonumKayit extends StatefulWidget {
  static double? latitude;
  static double? longitude;
  const KonumKayit({Key? key}) : super(key: key);

  @override
  _KonumKayitState createState() => _KonumKayitState();
}

class _KonumKayitState extends State<KonumKayit> {
  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);
    await locationProvider.requestUserLocation();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Consumer<LocationProvider>(
          builder: (context, locationProvider, _) {
            if (locationProvider.showDialog) {
              return AlertDialog(
                title: const Text('Adres Bilgisi'),
                content: locationProvider.userAddress != null && locationProvider.userAddress!.isNotEmpty
                    ? Text('Adresiniz: ${locationProvider.userAddress![0]}')
                    : const Text('Adres bilgisi bulunamadı.'),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      locationProvider.toggleShowDialog();
                      Navigator.pop(context);
                    },
                    child: const Text('Reddet'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      locationProvider.toggleShowDialog();
                      Navigator.pop(context);
                    },
                    child: const Text('Onaylıyorum'),
                  ),
                ],
              );
            } else {
              return const CircularProgressIndicator(color: Colors.deepPurple);
            }
          },
        ),
      ),
    );
  }
}

class LocationProvider extends ChangeNotifier {
  final Gps _gps = Gps();
  Position? _userPosition;
  List<Placemark>? _userAddress;
  Exception? _exception;
  bool _showDialog = false;

  Position? get userPosition => _userPosition;
  List<Placemark>? get userAddress => _userAddress;
  Exception? get exception => _exception;
  bool get showDialog => _showDialog;

  Future<void> requestUserLocation() async {
    try {
      final Position position = await _gps.getUserLocation();
      _userPosition = position;
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        _userAddress = placemarks;
        _showDialog = true;
      }
    } catch (e) {
      _exception = e as Exception?;
      _showDialog = true;
    }
    notifyListeners();
  }

  void toggleShowDialog() {
    _showDialog = !_showDialog;
    notifyListeners();
  }

  @override
  void dispose() {
    _gps.StopPositionStream();
    super.dispose();
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
    return permission == LocationPermission.whileInUse || permission == LocationPermission.always;
  }

  Future<Position> getUserLocation() async {
    bool permissionGranted = await requestPermission();
    if (!permissionGranted) {
      throw Exception("Kullanıcı GPS iznini vermedi.");
    }
    return Geolocator.getCurrentPosition();
  }

  Future<void> startPositionStream(Function(Position position) callback) async {
    bool permissionGranted = await requestPermission();
    if (!permissionGranted) {
      throw Exception("Kullanıcı GPS iznini vermedi.");
    }
    _positionStream = Geolocator.getPositionStream().listen(callback);
  }

  void StopPositionStream() {
    _positionStream.cancel();
  }
}
