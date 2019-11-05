import 'package:kudians/holidays.dart';

class HolidaysCache{
  static final HolidaysCache _singleton = HolidaysCache._internal();
  List<Holidays> _holidaysList;
  List<DateTime> _holiDates;
  int _numOfHolidays;
  factory HolidaysCache(){
    return _singleton;
  }
  HolidaysCache._internal(){
    _holidaysList=List<Holidays>();
    _holiDates=List<DateTime>();
    _numOfHolidays=0;
  }
  void setHolidays(List<Holidays> holidayList){
    this._holidaysList=holidayList;
  }
  void setHolidates(List<DateTime> holidates){
    this._holiDates=holidates;
  }
  void setNumOfHolidays(){
    this._numOfHolidays=_holidaysList.length;
  }
  List<Holidays> getHolidaysList(){
    return this._holidaysList;
  }
  List<DateTime> getHolidates(){
    return this._holiDates;
  }
  int getNumOfHolidays(){
    return this._numOfHolidays;
  }
  bool isCached(){
    return _holidaysList.isNotEmpty;
  }
}

