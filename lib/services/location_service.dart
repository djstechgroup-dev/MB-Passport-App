import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;

class LocationService {
  Future<LocationData?> getLatLong() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionLocation;
    LocationData locData;

    serviceEnabled = await location.serviceEnabled();
    if(!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionLocation = await location.hasPermission();
    if(permissionLocation == PermissionStatus.denied) {
      permissionLocation = await location.requestPermission();
      if(permissionLocation != PermissionStatus.granted) {
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

  Future<List<geo.Location>> getLatLongFromAddress(String address) async {
    List<geo.Location> locations = [];
    try {
      locations = await geo.locationFromAddress(address);
      return locations;
    } catch(e) {
      return locations;
    }
  }
}