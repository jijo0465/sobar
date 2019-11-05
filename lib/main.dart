import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kudians/firebase_services.dart';
import 'package:kudians/holidays.dart';
import 'package:kudians/holidays_cache.dart';
import 'package:kudians/kuppi.dart';
import 'package:kudians/price_list.dart';
import 'package:kudians/price_list_cache.dart';
import 'package:kudians/profile_page.dart';
import 'package:kudians/user_cache.dart';
import 'bar_map.dart';
import 'calender_page.dart';
import 'package:kudians/users.dart';

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
  static const List<Widget> _bottom_nav_options = <Widget>[
    BarMap(),
    PriceList(),
    CalendarPage(),
    ProfilePage(),
];

  @override
  void initState() {
    if(!UserCache().isCached()){
      setUser();
    }
    if(!PriceListCache().isCached()){
      setAllKuppi();
    }
    if(!HolidaysCache().isCached()){
      setHolidays();
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.1,0.3, 0.5, 0.7,0.8, 0.9], 
                colors: <Color>[
                  Colors.black,
                  Colors.grey[900],
                  Colors.grey[800],
                  Colors.grey[700],
                  Colors.grey[600],
                  Colors.grey[500],
                  ],
              )
            ),
        child: Stack(children: <Widget>[
          Center(child: _bottom_nav_options.elementAt(bottomNavSelected)),
          Container(
            
            height:300,
            width: 100,
            margin: EdgeInsets.fromLTRB(12, 45, 0, 0),
            alignment: Alignment.topLeft,
            child: Image.asset("assets/sobar_logo.png")
          )
        ],),
      ),
      
      bottomNavigationBar: _bottomNavigationBar()
        );
      }

  Widget _bottomNavigationBar(){
    return Container(
      child: BottomNavyBar(
        showElevation: true,
        iconSize: 20,
        selectedIndex: bottomNavSelected,
        backgroundColor: Colors.black,
        onItemSelected: (index){
          if(index!=0){
            BarMap.closeBottomSheet();
          }
          
          setState(() {
          bottomNavSelected=index;
          });
        },
   items: [
       BottomNavyBarItem(
         icon: Icon(Icons.map,),
         title: Text('Map'),
         activeColor: Colors.orange[900],
         inactiveColor: Colors.orange
       ),
       BottomNavyBarItem(
           icon: Icon(Icons.show_chart),
           title: Text('Price'),
           activeColor: Colors.orange[900],
           inactiveColor: Colors.orange
       ),
       BottomNavyBarItem(
           icon: Icon(Icons.calendar_today),
           title: Text('Holidays'),
           activeColor: Colors.orange[900],
           inactiveColor: Colors.orange
       ),
       BottomNavyBarItem(
           icon: Icon(Icons.supervised_user_circle),
           title: Text('Profile'),
           activeColor: Colors.orange[900],
           inactiveColor: Colors.orange
       )
   ],),
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
}
