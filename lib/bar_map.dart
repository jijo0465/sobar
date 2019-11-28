import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kudians/bottom_sheet_address_phone.dart';
import 'package:kudians/bottom_sheet_header.dart';
import 'package:kudians/bottom_sheet_title.dart';
import 'package:kudians/editor_page.dart';
import 'package:kudians/phone_signin_page.dart';
import 'package:kudians/user_cache.dart';
import 'package:kudians/map_cache.dart';
import 'package:kudians/place_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kudians/firebase_services.dart';
import 'package:kudians/photo_list.dart';
import 'package:kudians/review_list.dart';
import 'package:kudians/review_rate.dart';
import 'package:kudians/sobar_divider.dart';
import 'package:kudians/suggest_edit.dart';
import 'package:kudians/bars.dart';
import "package:google_maps_webservice/places.dart";
import 'package:flutter/services.dart' show rootBundle;
import 'package:stopper/stopper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timeago/timeago.dart' as timeago;

const MAP_API="AIzaSyAR6yclpjdj-1q8bwtOdvYm5JpKG7KOmCU";

class BarMap extends StatefulWidget{
  const BarMap();
  @override
  State<StatefulWidget> createState() {
    return _BarMap();
      }
}
        
class _BarMap extends State<BarMap>{
  PersistentBottomSheetController bottomSheetController;
  Geolocator _geolocator;
  Position position;
  String _mapStyle;
  var imgRef;
  GoogleMapController mapController;
  Set<Marker> markers;
  FirebaseServices firebaseServices;
  List<Bars> allBars;
  List<PlaceData> allBevco;
  List<PlaceData> allToddy;
  BitmapDescriptor toddyIcon;
  BitmapDescriptor barIcon;
  bool isMarkerTapped;
  GoogleMapsPlaces places;
  PlaceDetails placeDetails;
  PlacesDetailsResponse placesDetailsResponse;
  Bars tappedBar;
  bool urlSet=false;
  List<String> url;
  String filterChoice;
  List<PlaceData> allPlaces;
  bool isLocationEnabled=false;
  LatLng _center = LatLng(9.9312, 76.2673);
  final snackBar = SnackBar(content: Text('Please allow the location permission!'));
  PermissionStatus _status;
  Map<String,dynamic> userReview;
  bool isUserReviewed=false;
  @override
  void initState() {
    _geolocator=Geolocator();
    checkPermission();
    // setUserLocation();
        super.initState();
        filterChoice="bevco";
        rootBundle.loadString('assets/map_style.json').then((string) {
        _mapStyle = string;
        });
        places = GoogleMapsPlaces(apiKey: MAP_API);
        allBevco=List<PlaceData>();
        isMarkerTapped=false;
        allPlaces=List<PlaceData>();
        if(MapCache().isIconsCached()){
          barIcon=MapCache().getBevcoIcon();
          toddyIcon=MapCache().getToddyIcon();
        }else{
          BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size.fromHeight(20)), 'assets/bevco_marker.png')
            .then((onValue) {
              setState(() {
                barIcon = onValue;
              });
              
              BitmapDescriptor.fromAssetImage(
                ImageConfiguration(size: Size(15, 15)), 'assets/toddy_marker.png')
                .then((value) {
                  setState(() {
                    toddyIcon = value;
                  });
                  
                  MapCache().setIcons(toddyIcon, barIcon);
            });
        });
        }
        
        allBars=List<Bars>();
        firebaseServices=FirebaseServices();
        // firebaseServices.getAllBars().then((bars){
        //   setState(() {
        //     allBars=bars;
        //   });
        // });
        if(MapCache().isAllBevcoCached()){
          setState(() {
            allBevco=MapCache().getAllBevco();
          });
          
        }else{
          // firebaseServices.getAllBevco().then((bevco){
          // setState(() {
          //   allBevco=bevco;
          // });
          // MapCache().setAllBevco(allBevco);
          // });
        }
        if(MapCache().isAllToddyCached()){
          setState(() {
           allToddy=MapCache().getAllToddy();
          });
        }else{
          // firebaseServices.getAllToddy().then((toddy){
          // setState(() {
          //   allToddy=toddy;
          // });
          // MapCache().setAllToddy(allToddy);
          // });
        }
        
      }
      void _onMapCreated(GoogleMapController controller) {
        mapController = controller;
        mapController.setMapStyle(_mapStyle);
      }
      @override
      Widget build(BuildContext context) {
        if(filterChoice=="bevco"){
          imgRef=FirebaseStorage.instance.ref().child('kerala_bevco');
          markers=Set<Marker>();
          if(allBevco!=null){
          for(PlaceData bevco in allBevco){
            Marker marker=getMarker(bevco);
              markers.add(marker);
            }
          }
        }else if(filterChoice=="toddy"){
          imgRef=FirebaseStorage.instance.ref().child('kerala_toddy_shops');
          markers=Set<Marker>();
          if(allToddy!=null){
          for(PlaceData toddy in allToddy){
            Marker marker=getMarker(toddy);
              markers.add(marker);
            }
          }
        }
        
        return Container(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
            Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              tiltGesturesEnabled: true,
              mapToolbarEnabled: false,
              mapType: MapType.normal,
              markers: markers,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 8.0,
                ))),
                //   Positioned(
                //   bottom: 0.145*MediaQuery.of(context).size.height,
                //   child: Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(6),
                //       color: Colors.deepOrange[200].withOpacity(0.1),
                //     ),
                //     alignment: Alignment.center,
                //     width: 0.72*MediaQuery.of(context).size.width,
                //     height: 30,
                //     child: ClipRRect(
                //       clipBehavior: Clip.antiAlias,
                //       borderRadius: BorderRadius.all(Radius.circular(6)),
                //         child: BackdropFilter (
                //         filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                //           child: Marquee(
                //           text: 'Alcohol Consumption is injurious to health',
                //           style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red[700]),
                //           scrollAxis: Axis.horizontal,
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           blankSpace: 40.0,
                //           velocity: 100.0,
                //           pauseAfterRound: Duration(seconds: 1),
                //           startPadding: 20.0,
                //           accelerationDuration: Duration(seconds: 1),
                //           accelerationCurve: Curves.linear,
                //           decelerationDuration: Duration(milliseconds: 500),
                //           decelerationCurve: Curves.easeOut,
                //         ),
                //       ),
                //     )
                //   ),
                // ),
                Positioned(
                  top: MediaQuery.of(context).size.height*0.082,
                  child: Container(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      width: MediaQuery.of(context).size.width*0.5,
                      child: CupertinoSegmentedControl(
                        pressedColor: Colors.deepOrange.withOpacity(0.2),
                        borderColor: Colors.transparent,
                        children: {
                          'bevco':Container(
                            child:Text("Bevco",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
                          'toddy':Container(child:Text("Toddy",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),))
                        },
                        selectedColor: Colors.deepOrange,
                        groupValue: filterChoice,
                        onValueChanged: ((value){
                          try{
                              bottomSheetController.close();
                            }catch(e){
                              
                            }
                          mapController.animateCamera(CameraUpdate.newCameraPosition(
                          CameraPosition(
                              target: _center, zoom: 13)));
                          setState(() {
                            filterChoice=value; 
                          });
                        }),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height*0.13,
                  right: MediaQuery.of(context).size.width*0.05,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                      child: Container(
                        child: FloatingActionButton(
                          hoverElevation: 25,
                          splashColor: Colors.deepOrange,
                          elevation: 32,
                          backgroundColor: Colors.deepOrange[200].withOpacity(0.13),
                          foregroundColor: Colors.deepOrange,
                          child: Icon(Icons.add_location,size: 30,),
                          onPressed: ()async{
                            if(!UserCache().isCached()){
                              await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                                return PhoneSignInPage();
                              
                              }));
                            }if(UserCache().isCached()){
                              PlaceData pd=PlaceData(0,_center,'','',0.0,0,'','');
                              await Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditorPage(placeData: pd,type: filterChoice)));
                            }
                          },
                        ),
                    ),
                    ),
                  ),
                )
    
            
          ]),
        );
      }
      Marker getMarker(PlaceData bevco){
        BitmapDescriptor marker;
        if(filterChoice=='bevco'){
          marker=barIcon;
        }else if(filterChoice=='toddy'){
          marker=toddyIcon;
        }
        return Marker(markerId: MarkerId(bevco.placeId.toString()),
        position: bevco.placeLocation, 
        icon: marker,
        onTap: (){
          onMarkerTapped(bevco);
        });
        }
                  
      void onMarkerTapped(PlaceData place) async{
          mapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: place.placeLocation, zoom: 15)));
              
              stopperBottomSheet(context,place);
              
      }
    
      Future<String> getUrl(placeId,photoId) async {
        String url = await imgRef.child(placeId.toString()+'_'+photoId.toString()+'.jpg').getDownloadURL();
        return url;
      }
      stopperBottomSheet(context,PlaceData place){
        isUserReviewed=false;
        int placeId=place.placeId;
        String placePlaceId='';
        url=List<String>();
        List<Map<String,dynamic>> reviews=List();
        List<Map<String,dynamic>> sobarReviews=List();
        firebaseServices.getPhotoReview(placeId,filterChoice).then((value){
          setState(() {
              reviews=value['reviews'];
            });
          sobarReviews=value['sobar_reviews'];
          if(UserCache().isCached()&& sobarReviews.isNotEmpty){
            for(int i=0;i<sobarReviews.length;i++){
              Map<String,dynamic> rev=sobarReviews[i];
              if(UserCache().getUser().userId==rev['author_id']){
                userReview=rev;
                userReview['relative_time_description']=timeago.format(DateTime.now().subtract(DateTime.now().difference(userReview['time'].toDate())));
                reviews.insert(0, userReview);
                setState(() {
                  isUserReviewed=true;
                });
                  continue;
              }
            }
          }
            
        for(int photoId in value['photos']){
          getUrl(placeId,photoId).then((value){
            url.add(value);
          });
        }
        setState(() {
          urlSet=true;
        });
        });
        final h = MediaQuery.of(context).size.height;
        String type;
        String address;
        String phone;
        LatLng latLng;
        
        if(filterChoice=='bevco'){
          type="Bevco Outlet";
        }else if(filterChoice=='toddy'){
          type="Toddy Shop";
        }
          address=place.placeAddress;
          phone=place.placePhone;
          latLng=place.placeLocation;
          if(place.placePlaceId!=null){
            placePlaceId=place.placePlaceId;
        }
    
        bottomSheetController=showStopper(
          userCanClose: true,
          context: context,
          initialStop: 0,
          stops: [0.4 * h, 0.95*h],
          builder: (context, scrollController, scrollPhysics, stop) {
            return Container(
              color: Colors.black,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      BottomSheetHeader(title: place.placeName,rating: place.placeRating,totalRated: place.placeTotalRating,type: type,bottState: stop,),
                      Expanded(
                        child: CustomScrollView(
                        slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                SobarDivider(),
                                BottomSheetAddressPhone(address: address,phone: phone, latLng: latLng, placeId: placePlaceId, name:place.placeName),
                                SobarDivider(),
                                url.length!=0?
                                Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      child: BottomSheetTitle(title:"Photos"),
                                    ),
                                    PhotoList(count: url.length,url: url, source: "network",)
                                  ],
                                )
                                :Container(),
                                SuggestEdit(placeData: place,type:filterChoice),
                                isUserReviewed?ReviewRate(placeId: place.placeId,placeName: place.placeName,
                                rating:  userReview['rating']*1.0,
                                placeType: filterChoice,isUserReviewed: isUserReviewed,):
                                ReviewRate(placeId: place.placeId,placeName: place.placeName,
                                isReviwed: (value){
                                  if(value!=null){
                                    userReview=value.toMap();
                                    reviews.insert(0, value.toMap());
                                    setState(() {
                                      isUserReviewed=true;
                                    });
                                  }
                                },
                                rating:  0.0,
                                placeType: filterChoice,isUserReviewed: isUserReviewed,),
                                SobarDivider(),
                              ]
                            ),
                          ),
                          ReviewList(reviews: reviews)
                        ],
                        controller: scrollController,
                        physics: scrollPhysics,
                                  ),
                      )
                      
                    ],
                  ),
                            ),
                          ),
            );
                      },
                    );     
      }
    
      setUserLocation()async{
        // Scaffold.of(context).showSnackBar(snackBar);
        await _geolocator.checkGeolocationPermissionStatus().then((status) async {
          if(status==GeolocationStatus.granted){
            position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
             _center=LatLng(position.latitude, position.longitude);
            mapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: _center, zoom: 13)));
          }
        });
        // position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        // geolocationStatus
      }
    
      void checkPermission() async{
        PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
          _status=permission;
        if(_status==PermissionStatus.unknown||_status==PermissionStatus.denied){
          await PermissionHandler().requestPermissions([PermissionGroup.locationWhenInUse]).then((value){
            final status = value[PermissionGroup.locationWhenInUse];
            if(status!=PermissionStatus.granted){
              PermissionHandler().openAppSettings();
            }
          });
        }
        setUserLocation();
      }
}