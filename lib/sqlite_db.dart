import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kudians/holidays.dart';
import 'package:kudians/holidays_cache.dart';
import 'package:kudians/kuppi.dart';
import 'package:kudians/map_cache.dart';
import 'package:kudians/place_data.dart';
import 'package:kudians/price_list_cache.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDb{
  Database db;

  Future<void> openSqlite()async{
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, "sobar_db.db");

      // Check if the database exists
      var exists = await databaseExists(path);
    if (!exists) {
      // Should happen only the first time you launch your application

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
        
      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "sobar_db.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      
      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);

    } else {
    }
    // open the database
    db = await openDatabase(path, readOnly: true);
    List<Map<String, dynamic>> records = await db.query('kerala_bevco_price');
    if(records.isNotEmpty){
      List<Kuppi> kuppiList=List();
      for(int i=0;i<records.length;i++){
        Kuppi kuppi=Kuppi(records[i]['name'], records[i]['price'], records[i]['category'],
         records[i]['size'], records[i]['volume']);
        kuppiList.add(kuppi);
    }
    kuppiList.sort((a,b)=>a.name.compareTo(b.name));
    PriceListCache().setAllKuppi(kuppiList);
    }
        List<Map<String, dynamic>> holidaysRecord = await db.query('kerala_holidays');
        if(holidaysRecord.isNotEmpty){
          List<Holidays> holidayList=List();
          List<DateTime> holidates =List();
          DateTime today=DateTime.now();
          for(int i=0;i<holidaysRecord.length;i++){
            if(today.isBefore(DateTime.parse(holidaysRecord[i]['date']+" 00:00:00"))){
              Holidays holidays = Holidays(holidaysRecord[i]['id'].toString(), DateTime.parse(holidaysRecord[i]['date']+" 00:00:00"),
               holidaysRecord[i]['reason']);
              holidayList.add(holidays);
              holidates.add(DateTime.parse(holidaysRecord[i]['date']));
           }
          }
      holidayList.sort((a,b)=>a.date.compareTo(b.date));    
      HolidaysCache().setHolidays(holidayList);
      HolidaysCache().setHolidates(holidates);
      HolidaysCache().setNumOfHolidays();
      }
      List<Map<String, dynamic>> bevcos = await db.query('bevco_locations');
      if(bevcos.isNotEmpty){
          List<PlaceData> bevcoData=List();
          for(int i=0;i<bevcos.length;i++){
            LatLng location=LatLng(bevcos[i]['latitude'], bevcos[i]['longitude']);
            PlaceData bevco=PlaceData(bevcos[i]['id'], location, bevcos[i]['name'], bevcos[i]['address'], bevcos[i]['rating'], bevcos[i]['total_rating'], bevcos[i]['place_id'], bevcos[i]['phone']);
            bevcoData.add(bevco);
          }
      MapCache().setAllBevco(bevcoData);
      }
      List<Map<String, dynamic>> toddy = await db.query('toddy_locations');
      if(toddy.isNotEmpty){
          List<PlaceData> toddyData=List();
          for(int i=0;i<toddy.length;i++){
            LatLng location=LatLng(toddy[i]['latitude'], toddy[i]['longitude']);
            PlaceData toddys=PlaceData(toddy[i]['id'], location, toddy[i]['name'], toddy[i]['address'], toddy[i]['rating'], toddy[i]['total_rating'], toddy[i]['place_id'], toddy[i]['phone']);
            toddyData.add(toddys);
          }
      MapCache().setAllToddy(toddyData);
      }
  }


    
  //   Future<void> setAllKuppi() async {
  //   List<Kuppi> allKuppis;
  //   await FirebaseServices().getAllKuppi().then((value){
  //     allKuppis=value;
  //   });
  //   allKuppis.sort((a,b)=>a.name.compareTo(b.name));
  //   PriceListCache().setAllKuppi(allKuppis);
  // }
  // Future<void> setHolidays()async{
  //   List<Holidays> holidays;
  //   List<DateTime> holidates=List<DateTime>();
  //   await FirebaseServices().getAllHolidays().then((value){
  //     holidays = value;
  //     });
  //   int _numOfHolidays=holidays.length;
  //   holidays.sort((a,b)=>a.date.compareTo(b.date));
  //       for(int i=0;i<_numOfHolidays;i++){
  //         holidates.add(holidays[i].date);
  //       }
  //   HolidaysCache().setHolidays(holidays);
  //   HolidaysCache().setHolidates(holidates);
  //   HolidaysCache().setNumOfHolidays();
  // }
}