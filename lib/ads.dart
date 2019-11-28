class Ads {
  bool isPriceAdShown;
  bool isCalendarAdShown;
  static final Ads _singleton = Ads._internal();
  factory Ads() {
    return _singleton;
  }

  Ads._internal() {
    isPriceAdShown=false;
    isCalendarAdShown=false;
  }
  
}