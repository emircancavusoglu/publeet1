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
  _KonumKayitState createState() => _KonumKayitState();
}

class _KonumKayitState extends State<KonumKayit> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
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

  LocationProvider() {
    _gps.startPositionStream(_handlePositionStream).catchError((e) {
      _exception = e as Exception?;
      _showDialog = true;
      notifyListeners();
    });
  }

  void _handlePositionStream(Position position) async {
    _userPosition = position;
    notifyListeners();

    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        _userPosition!.latitude,
        _userPosition!.longitude,
      );
      if (placemarks.isNotEmpty) {
        _userAddress = placemarks;
        _showDialog = true;
        notifyListeners();
      }
    } catch (e) {
      _exception = e as Exception?;
      _showDialog = true;
      notifyListeners();
    }
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
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
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
