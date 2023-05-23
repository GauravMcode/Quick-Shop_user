import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class MapRepository {
  static Future<Position> getLocation() async {
    //check if location is on
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      return Future.error('Location is disabled');
    }

    //check for location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permission is denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location Permission is denied permanently');
    }

    //get current location
    return await Geolocator.getCurrentPosition();
  }

  static Future<Placemark> getAddress({required double lat, required double long}) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    return placemarks[0];
  }
}
