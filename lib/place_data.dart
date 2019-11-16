import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceData{
  final int placeId;
  final LatLng placeLocation;
  final String placeName;
  final String placeAddress;
  final double placeRating;
  final int placeTotalRating;
  final String placePlaceId;
  String placeDistrict;
  final String placePhone;
  List<Map<String,dynamic>> reviews;
  List<int> photoId;
  PlaceData(this.placeId, this.placeLocation, this.placeName, this.placeAddress, this.placeRating, this.placeTotalRating, this.placePlaceId, this.placePhone);
}