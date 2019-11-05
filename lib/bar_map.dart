import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kudians/bottom_sheet_address_phone.dart';
import 'package:kudians/bottom_sheet_header.dart';
import 'package:kudians/filter_box.dart';
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

const MAP_API="AIzaSyAR6yclpjdj-1q8bwtOdvYm5JpKG7KOmCU";

class BarMap extends StatefulWidget{
  static PersistentBottomSheetController bottomSheetController;
  const BarMap();
  @override
  State<StatefulWidget> createState() {
    return _BarMap();
      }

  static closeBottomSheet() async {
    print("object");
    print(bottomSheetController);
    if(bottomSheetController!=null){
      bottomSheetController.close();
      bottomSheetController=null;
    }
      }
  setBottomSheetController(controller){
    bottomSheetController=controller;
  }
}
        
class _BarMap extends State<BarMap>{
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
  String tappedMarkerId;
  GoogleMapsPlaces places;
  PlaceDetails placeDetails;
  PlacesDetailsResponse placesDetailsResponse;
  Bars tappedBar;
  PlaceData tappedPlace;
  bool urlSet=false;
  List<String> url;
  String filterChoice;
  List<PlaceData> allPlaces;
  bool isLocationEnabled=false;
  LatLng _center = LatLng(9.9312, 76.2673);
  final snackBar = SnackBar(content: Text('Please allow the location permission!'));
  @override
  void initState() {
    _geolocator=Geolocator();
    setUserLocation();
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
          barIcon = onValue;
          BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(15, 15)), 'assets/toddy_marker.png')
            .then((value) {
              toddyIcon = value;
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
      firebaseServices.getAllBevco().then((bevco){
      setState(() {
        allBevco=bevco;
      });
      MapCache().setAllBevco(allBevco);
      });
    }
    if(MapCache().isAllToddyCached()){
      setState(() {
       allToddy=MapCache().getAllToddy(); 
      });
    }else{
      firebaseServices.getAllToddy().then((toddy){
      setState(() {
        allToddy=toddy;
      });
      MapCache().setAllToddy(allToddy);
      });
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
    }else if(filterChoice=="bar"){
      markers=Set<Marker>();
    }
    
    return Container(
      
      child: Stack(children: <Widget>[
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
              Positioned(
              top: 0.85*MediaQuery.of(context).size.height,
              left: 0.3*MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.deepOrange,
                ),
                alignment: Alignment.center,
                width: 0.4*MediaQuery.of(context).size.width,
                height: 30,
                child: filterChoice=="bevco"?Text("Showing Bevco Outlets",style: 
                    TextStyle(color: Colors.white),):filterChoice=="toddy"?Text("Showing Toddy Shops",style: TextStyle(color: Colors.white)):
                    Text("Bars on the way!",style: TextStyle(color: Colors.white)),
              ),
            ),
            Positioned(
              top: 0.05*MediaQuery.of(context).size.height,
              left: 0.7*MediaQuery.of(context).size.width,
              child: AnimatedFab(onTap: (value){
                BarMap.closeBottomSheet();
                setState(() {
                 filterChoice=value; 
                });
              },),
            ),

        
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
    url=List<String>();
    for(int photoId in place.photoId){
      getUrl(place.placeId,photoId).then((value){
      url.add(value);
      });
    }
    setState(() {
      urlSet=true;
    });
    
      // placesDetailsResponse = await places.getDetailsByPlaceId(bar.placeId);
      // if(placesDetailsResponse.status=="OK"){
      //   setState(() {
      //    placeDetails=placesDetailsResponse.result;
      //   });
      //    print(placesDetailsResponse.result.name);
      // }else if(placesDetailsResponse.status=="OVER_QUERY_LIMIT"){
      //   sleep(Duration(seconds: 3));
      //   setState(() {
      //    placeDetails=placesDetailsResponse.result;
      //   });
      // }
      tappedPlace=tappedPlace;
      tappedMarkerId=place.placeId.toString();
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: place.placeLocation, zoom: 15)));
          setState(() {
            isMarkerTapped=true;
          });
          stopperBottomSheet(context,place);
  }

  Future<String> getUrl(placeId,photoId) async {
    String url = await imgRef.child(placeId.toString()+'_'+photoId.toString()+'.jpg').getDownloadURL();
    return url;
  }
  stopperBottomSheet(context,PlaceData place){
    final h = MediaQuery.of(context).size.height;
    String type;
    String address;
    String phone;
    LatLng latLng;
    String placeId='';
    var reviews=place.reviews;
    if(place is PlaceData){
      type="Bevco Outlet";
      address=place.placeAddress;
      phone=place.placePhone;
      latLng=place.placeLocation;
      if(place.placePlaceId!=null){
        placeId=place.placePlaceId;
      }
    }
    var bottomSheetController=showStopper(
      userCanClose: false,
      context: context,
      stops: [83,0.5 * h, 0.88*h],
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
              color: Colors.orange[200],
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
                            BottomSheetAddressPhone(address: address,phone: phone, latLng: latLng, placeId: placeId, name:place.placeName),
                            SobarDivider(),
                            urlSet?PhotoList(count: url.length,url: url,title: place.placeName, source: "network",):Container(),
                            SuggestEdit(placeData: place,type:filterChoice),
                            ReviewRate(placeId: place.placeId,placeName: place.placeName,placeType: filterChoice),
                            SobarDivider(),
                          ]
                        ),
                      ),ReviewList(reviews: reviews,)
                      
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
      widget.setBottomSheetController(bottomSheetController);        
  }

  setUserLocation()async{
    
    // Scaffold.of(context).showSnackBar(snackBar);
    _geolocator.checkGeolocationPermissionStatus().then((status) async {
      if(status==GeolocationStatus.granted){
        position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
         isLocationEnabled=true;
         _center=LatLng(position.latitude, position.longitude);
        mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: _center, zoom: 13)));
      }
    });
    // position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // geolocationStatus
  }
}