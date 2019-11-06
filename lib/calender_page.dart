import 'package:flutter/material.dart';
import 'package:kudians/calendar.dart';
import 'package:kudians/firebase_services.dart';
import 'package:kudians/holidays_cache.dart';
import 'package:kudians/sobar_holiday_list.dart';
import 'holidays.dart';

class CalendarPage extends StatefulWidget{
  const CalendarPage();
  
  @override
  State<StatefulWidget> createState() {
    return _CalenderPage();
      }
    }
    
  class _CalenderPage extends State<CalendarPage> {
    List<DateTime> _holidays;
    List<Holidays> holidays;
    int _numOfHolidays;
    bool isHolidaySet= false;
    DateTime today = DateTime.now();
      @override
    void initState() {
      if(HolidaysCache().isCached()){
         holidays=HolidaysCache().getHolidaysList();
        _holidays=HolidaysCache().getHolidates();
        _numOfHolidays=HolidaysCache().getNumOfHolidays();
        print(_numOfHolidays);
        setState(() {
         isHolidaySet=true; 
        });
      }else{
        setHolidays();
      }
      super.initState();
  }
      @override
      Widget build(BuildContext context) {
        return isHolidaySet? Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 90, 0, 0),
                child: Calendar(_holidays),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 65),
                child: SizedBox(
                  height: 110,
                  child: SobarHolidayList(holidays: holidays,numOfHolidays: _numOfHolidays,),
                ),
              )
            ],
          ),
        ):Container(
          child: Icon(Icons.local_bar),
        );
    }
    void setHolidays(){
      _holidays = List<DateTime>();
      FirebaseServices().getAllHolidays().then((value){
        holidays = value;
        _numOfHolidays=holidays.length;
        for(int i=0;i<_numOfHolidays;i++){
          _holidays.add(holidays[i].date);
        }
        holidays.sort((a,b)=>a.date.compareTo(b.date));
        setState(() {
          isHolidaySet=true;
        });
      });
    }
}