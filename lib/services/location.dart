import 'package:geolocator/geolocator.dart';

class LatLong{

  LatLong({this.latitude, this.longitude});

  double latitude;
  double longitude;
}

class Location{

  static Future<LatLong> getLocation() async {
    try{
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      return LatLong(latitude: position.latitude, longitude: position.longitude);
    }catch(e){
      print(e);
      return null;
    }
  }
}