import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kudians/firebase_services.dart';
import 'package:kudians/holidays.dart';
import 'package:kudians/holidays_cache.dart';
import 'package:kudians/kuppi.dart';
import 'package:kudians/loading.dart';
import 'package:kudians/map_cache.dart';
import 'package:kudians/price_list.dart';
import 'package:kudians/price_list_cache.dart';
import 'package:kudians/profile_page.dart';
import 'package:kudians/user_cache.dart';
import 'bar_map.dart';
import 'calender_page.dart';
import 'package:kudians/users.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kudians/sqlite_db.dart';
import 'my_flutter_app_icons.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sobar',
      theme: ThemeData(
      ),
      home: MyHomePage(title: 'SOBAR'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SobarUsers sobarUser;
  int bottomNavSelected=0;
  bool holiday=true;
  bool isEverythingCached=false;
  bool isIconsCached =false;
  final FirebaseMessaging _messaging = FirebaseMessaging();
  static const List<Widget> _bottom_nav_options = <Widget>[
    BarMap(),
    PriceList(),
    CalendarPage(),
    ProfilePage(),
];

  @override
  void initState() {
    
    SqliteDb().openSqlite().then((value){
      setState(() {
        isEverythingCached=true;
      });
    });
    if(!UserCache().isCached()){
      setUser();
    }
    // if(!PriceListCache().isCached()){
    //   setAllKuppi();
    // }
    // if(!HolidaysCache().isCached()){
    //   setHolidays();
    // }
    cacheIcons();
        _messaging.requestNotificationPermissions(
          const IosNotificationSettings(
            sound: true,
            badge: true,
            alert: true
          )
        );
        _messaging.configure(
          onMessage: (Map<String,dynamic> message)async{
            Scaffold.of(context).showSnackBar(messageSnackBar(message));
          },
          onLaunch: (Map<String,dynamic> message)async{
            Scaffold.of(context).showSnackBar(messageSnackBar(message));
          },
          onResume: (Map<String,dynamic> message)async{
            Scaffold.of(context).showSnackBar(messageSnackBar(message));
          },
        );
        _messaging.subscribeToTopic('holiday');
        super.initState();
      }
      @override
      Widget build(BuildContext context) {
        precacheImage(AssetImage('assets/background.png'), context);
        precacheImage(AssetImage('assets/no_alcohol.png'), context);
        precacheImage(AssetImage('assets/toddy_marker.png'), context);
        precacheImage(AssetImage('assets/bevco_marker.png'), context);
        precacheImage(AssetImage('assets/user_location.png'), context);
        SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: isEverythingCached&&isIconsCached? Container(
            child: Stack(
              children: <Widget>[
                bottomNavSelected!=0? Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: FittedBox(
                    fit:  BoxFit.fill,
                    child: Image.asset('assets/background.png')),
                ):Container(),
                Center(child: _bottom_nav_options.elementAt(bottomNavSelected)),
                bottomNavigationar()
                // Container(
                //   height:300,
                //   width: 100,
                //   margin: EdgeInsets.fromLTRB(12, 45, 0, 0),
                //   alignment: Alignment.topLeft,
                //   child: Image.asset("assets/sobar_logo.png")
                // )
              ],),
          ):Loading()
            );
          }
    
      void setUser(){
        FirebaseUser user;
        FirebaseAuth.instance.currentUser().then((value){
          user=value;
          if(user!=null){
            FirebaseServices().getSobarUser(user.uid).then((value){
              sobarUser=value;
              UserCache().setUser(sobarUser);
            });
          }
        });
      }
      Future<void> setAllKuppi() async {
        List<Kuppi> allKuppis;
        await FirebaseServices().getAllKuppi().then((value){
          allKuppis=value;
        });
        allKuppis.sort((a,b)=>a.name.compareTo(b.name));
        PriceListCache().setAllKuppi(allKuppis);
      }
      
      Future<void> setHolidays()async{
        List<Holidays> holidays;
        List<DateTime> holidates=List<DateTime>();
        await FirebaseServices().getAllHolidays().then((value){
          holidays = value;
          });
        int _numOfHolidays=holidays.length;
        holidays.sort((a,b)=>a.date.compareTo(b.date));
            for(int i=0;i<_numOfHolidays;i++){
              holidates.add(holidays[i].date);
            }
        
        HolidaysCache().setHolidays(holidays);
        HolidaysCache().setHolidates(holidates);
        HolidaysCache().setNumOfHolidays();
      }
      Widget messageSnackBar(message){
        return SnackBar(
          content: Container(
            child: Row(
              children: <Widget>[
                Text("Tomorrow will be a DRY Day!!",style: TextStyle(fontSize: 14),),
                Text(message.notification['title'],style: TextStyle(fontSize: 8))
              ],
            )),
          elevation: 9,
        );
      }
    
      Widget bottomNavigationar(){
        return Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                  Radius.circular(10)
                ),
                clipBehavior: Clip.antiAlias,
                    child: CupertinoTabBar(
                      iconSize: 22,
                    items: [BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  title: Text("Map",style: TextStyle(letterSpacing: 1)),
                  ),
                  BottomNavigationBarItem( 
                    icon: Icon(MyFlutterApp.price_list3),
                    title: Text("Price",style: TextStyle(letterSpacing: 1))
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(MyFlutterApp.no_alcohol_1),
                    title: Text("DRY Days",style: TextStyle(letterSpacing: 1))
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(MyFlutterApp.user_1),
                    title: Text("Profile",style: TextStyle(letterSpacing: 1),)
                  )],
                backgroundColor: Colors.white10,
                activeColor: Colors.deepOrange,
                inactiveColor: Colors.white,
                currentIndex: bottomNavSelected,
                onTap: ((index){
                  setState(() {
                    bottomNavSelected=index;
                  });
                }),
              ),
            ),
          );
      }
    
      void cacheIcons() async{
        BitmapDescriptor barIcon;
        BitmapDescriptor toddyIcon;
        BitmapDescriptor userIcon;
        await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size.fromHeight(20)), 'assets/bevco_marker.png')
            .then((onValue) {
              setState(() {
                barIcon = onValue;
              });
              
        });
        await BitmapDescriptor.fromAssetImage(
                ImageConfiguration(size: Size(15, 15)), 'assets/toddy_marker.png')
                .then((value) {
                  setState(() {
                    toddyIcon = value;
                  });
            });
        await BitmapDescriptor.fromAssetImage(
                ImageConfiguration(size: Size.fromHeight(20)), 'assets/user_location.png')
                .then((onValue) {
                  setState(() {
                    userIcon = onValue;
                  });
                });
                
                setState(() {
                  isIconsCached=true;
                });
        MapCache().setIcons(toddyIcon, barIcon, userIcon);
      }
}
