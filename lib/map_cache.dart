import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kudians/place_data.dart';

class MapCache {
  List<PlaceData> _alltoddy;
  List<PlaceData> _allBevco;
  BitmapDescriptor _toddyIcon;
  BitmapDescriptor _bevcoIcon;
  static final MapCache _singleton = MapCache._internal();
  factory MapCache() {
    return _singleton;
  }

  MapCache._internal() {
    _alltoddy=List<PlaceData>();
    _allBevco=List<PlaceData>();
  }

  void setAllToddy(List<PlaceData> allToddy){
    this._alltoddy=allToddy;
  }
  List<PlaceData> getAllToddy(){
    return this._alltoddy;
  }
  bool isAllToddyCached(){
    return this._alltoddy.isNotEmpty;
  }
    void setAllBevco(List<PlaceData> allBevco){
    this._allBevco=allBevco;
  }
  List<PlaceData> getAllBevco(){
    return this._allBevco;
  }
  bool isAllBevcoCached(){
    return this._allBevco.isNotEmpty;
  }
  void setIcons(BitmapDescriptor toddyIcon,BitmapDescriptor bevcoIcon){
    this._toddyIcon=toddyIcon;
    this._bevcoIcon=bevcoIcon;
  }
  bool isIconsCached(){
    return (!(this._bevcoIcon==null)||!(this._toddyIcon==null));
  }
  BitmapDescriptor getBevcoIcon(){
    return this._bevcoIcon;
  }
  BitmapDescriptor getToddyIcon(){
    return this._toddyIcon;
  }
}