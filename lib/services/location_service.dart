import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;

class LocationService {
  Future<loc.LocationData?> getLatLong() async {
    loc.Location location = loc.Location();

    bool serviceEnabled;
    loc.PermissionStatus permissionLocation;
    loc.LocationData locData;

    serviceEnabled = await location.serviceEnabled();
    if(!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionLocation = await location.hasPermission();
    if(permissionLocation == loc.PermissionStatus.denied) {
      permissionLocation = await location.requestPermission();
      if(permissionLocation != loc.PermissionStatus.granted) {
        return null;
      }
    }

    locData = await location.getLocation();
    return locData;
  }

  Future<List<geo.Placemark>> getLocation() async {
    double? lat;
    double? long;

    await getLatLong().then((value) {
      lat = value?.latitude;
      long = value?.longitude;
    });

    List<geo.Placemark> placemark =
        await geo.placemarkFromCoordinates(lat!, long!);

    return placemark;
  }
}