import 'package:location/location.dart';

class LocationInfo {
  double? longitude;
  double? latitude;



  Future<void> getUserLocationData() async {
    Location location = new Location();

    bool ?_serviceEnabled;
    PermissionStatus ?_permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }



    try {
      var currentLocation = await location.getLocation();
      longitude = currentLocation.longitude;
      latitude = currentLocation.latitude;
    } catch (e) {
      print(e);
    }
  }

  Future<bool> getUserLocationAndGPS() async {
    return await Location().requestService();
  }
}
