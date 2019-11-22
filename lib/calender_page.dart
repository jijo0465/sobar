import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kudians/calendar.dart';
import 'package:kudians/firebase_services.dart';
import 'package:kudians/holidays_cache.dart';
import 'package:kudians/sobar_holiday_list.dart';
import 'holidays.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'app_id.dart' show APP_ID;

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
    bool interstitialIsLoaded=false;
    static final MobileAdTargetingInfo targetingInfo= MobileAdTargetingInfo(
      testDevices: APP_ID !=null? [APP_ID] : null,
      keywords: ['Games','Puzzles']
    );

    InterstitialAd interstitialAd;
    InterstitialAd buildInterstitialAd(){
      return InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event){
          if(event==MobileAdEvent.failedToLoad){
            interstitialAd..load();
          }else if(event == MobileAdEvent.closed){
            interstitialAd = buildInterstitialAd()..load();
          }
        }
      );
    }
      @override
    initState() {
      if(HolidaysCache().isCached()){
         holidays=HolidaysCache().getHolidaysList();
        _holidays=HolidaysCache().getHolidates();
        _numOfHolidays=HolidaysCache().getNumOfHolidays();
        setState(() {
         isHolidaySet=true; 
        });
      }else{
        setHolidays();
      }
      FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
      interstitialAd = buildInterstitialAd()..load();
      interstitialAd..load()..show();
      super.initState();
  }
    @override
  void dispose() {
    interstitialAd?.dispose();
    super.dispose();
  }
      @override
      Widget build(BuildContext context) {
        return isHolidaySet? BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4,sigmaY: 4),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Container(
                //   padding: EdgeInsets.fromLTRB(20, 40, 0, 0),
                //   alignment: Alignment.centerLeft,
                //   child: Text('DRY Days',
                //       style: TextStyle(color: Colors.deepOrange,fontSize: 20,fontWeight: FontWeight.w500, letterSpacing: 0.3),),
                // ),
                SizedBox(
                  height: 40,
                ),
                Calendar(_holidays),
                SizedBox(
                  height: 110,
                  child: SobarHolidayList(holidays: holidays,numOfHolidays: _numOfHolidays,),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
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