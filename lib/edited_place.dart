import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EditedPlace{
  String database;
  String name;
  String address;
  String phone;
  bool isClosed;
  int placeId;
  LatLng location;
  EditedPlace(this.database,this.placeId,this.name,this.address,this.phone,this.isClosed,this.location);

  List<Map<String, dynamic>> toMapList() {
    return [{
      'database': database,
      'name': name,
      'address': address,
      'phone': phone,
      'isClosed': isClosed,
      'placeId': placeId,
      'location': GeoPoint(location.latitude, location.longitude)
    }];
  }
}