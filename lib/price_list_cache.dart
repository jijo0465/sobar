import 'package:kudians/kuppi.dart';

class PriceListCache {
  List<Kuppi> _allKuppi;
  static final PriceListCache _singleton = PriceListCache._internal();
  factory PriceListCache() {
    return _singleton;
  }

  PriceListCache._internal() {
    _allKuppi= List();
  }

  void setAllKuppi(List<Kuppi> allKuppi){
    this._allKuppi=allKuppi;
  }

  List<Kuppi> getAllKuppi(){
    return this._allKuppi;
  }
  
  bool isCached(){
    return this._allKuppi.isNotEmpty;
  }
}