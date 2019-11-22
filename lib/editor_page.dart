import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kudians/edited_place.dart';
import 'package:kudians/firebase_services.dart';
import 'package:kudians/place_data.dart';
import 'package:kudians/sobar_form_field.dart';

class EditorPage extends StatefulWidget{
  final PlaceData placeData;
  final String type;

  const EditorPage({Key key, @required this.placeData,this.type}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _EditorPage();
  }

}
class _EditorPage extends State<EditorPage>{
  int placeId;
  EditedPlace editedPlace;
  String newName;
  String newAddress;
  String newPhone;
  LatLng newLocation;
  bool isClosed;
  GoogleMapController mapController;
  Set<Marker> marker;
  LatLng currentLocation;
  ScrollController _scrollController;
  String type;
  bool isNewPlace;
  String title;
  String _mapStyle;
  @override
  void initState() {
    super.initState();
    type=widget.type;
    isClosed=false;
    currentLocation=widget.placeData.placeLocation;
    newName=widget.placeData.placeName;
    newAddress=widget.placeData.placeAddress;
    newLocation=widget.placeData.placeLocation;
    placeId=widget.placeData.placeId;
    newPhone=widget.placeData.placePhone;
    rootBundle.loadString('assets/map_style.json').then((string) {
        _mapStyle = string;
        });
    if(placeId==0){
      setState(() {
        isNewPlace=true;
        title="New Place";
      });
    }else{
      setState(() {
        isNewPlace=false;
        title=widget.placeData.placeName;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    marker=Set<Marker>();
    marker.add(Marker(markerId: MarkerId(widget.placeData.placeId.toString()),position: currentLocation));
    return Stack(
      children: <Widget>[
        Container(
              width: double.infinity,
              height: double.infinity,
              child: FittedBox(
                fit:  BoxFit.fill,
                child: Image.asset('assets/background.png')),
            ),
        Scaffold(
          resizeToAvoidBottomPadding: true,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(title,style: TextStyle(fontSize: 17.5),),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: isNewPlace!=null? Container(
            child:SingleChildScrollView(
              controller: _scrollController,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 0.35*MediaQuery.of(context).size.height,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: GoogleMap(
                          mapToolbarEnabled: false,
                          onMapCreated: (_mapController){
                            mapController=_mapController;
                            mapController.setMapStyle(_mapStyle);
                          },
                          onCameraMove: (value){
                            newLocation=value.target; 
                          },
                          onCameraIdle: (){
                          },
                          initialCameraPosition: CameraPosition(
                            target: widget.placeData.placeLocation,
                            zoom: 15,
                        )),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 21),
                          child: Icon(Icons.location_on,color: Colors.deepOrange,)),
                      )
                    ],
                  )
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 4, 4, 12),
                  // alignment: Alignment.centerRight,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text("Position the dropped pin to the correct location",
                    style: TextStyle(color: Colors.white70),),
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      isNewPlace?Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white.withOpacity(0.7)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Radio(
                              activeColor: Colors.deepOrange,
                              onChanged:(value){
                                setState(() {
                                  type=value;
                                });
                              },
                              value: 'bevco',
                              groupValue: type,),
                              Text('Bevco',style: TextStyle(color: Colors.white),),
                              SizedBox(width: 50,),
                              Radio(
                                activeColor: Colors.deepOrange,
                                onChanged:(value){
                                  setState(() {
                                    type=value;
                                  });
                                },
                              value: 'toddy',
                              groupValue: type,),
                              Text('Toddy',style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ):Container(),
                      SobarFormField(label: "Name",initialValue: widget.placeData.placeName,maxLines: 1,onChanged: (name){
                        newName=name;
                      }, enabled: true,),
                      SobarFormField(label: "Address",initialValue: widget.placeData.placeAddress,maxLines: 3,onChanged: (address){
                        newAddress=address;
                      }, enabled: true,),
                      SobarFormField(label: "Phone",initialValue: widget.placeData.placePhone,maxLines: 1,onChanged: (phone){
                        newPhone=phone;
                      }, enabled: true,),
                      ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                          child: Container(
                            margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
                            decoration: BoxDecoration(
                              color: Colors.orange[100].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8)
                            ),
                            child: !isNewPlace? 
                            Container(
                             child: ListTile(
                               onTap: (){
                                 setState(() {
                                  isClosed=!isClosed; 
                                 });
                               },
                               title: Text("Place does not exist",style: TextStyle(color: Colors.white),),
                               leading: Theme(
                                 data: ThemeData(unselectedWidgetColor: Colors.white),
                                 child: Checkbox(
                                    checkColor: Colors.white,
                                    value: isClosed, 
                                    activeColor: Colors.red[600],
                                    onChanged: (bool value) {
                                      setState(() {
                                        isClosed=!isClosed; 
                                        });
                                      },
                                    ),
                               ),
                                ),
                              ):Container(),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(8, 8, 8, 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: SizedBox(
                          height: 50,
                          child: RaisedButton(
                            elevation: 6,
                            color: Colors.black,
                            child:Text("Submit",style: TextStyle(color: Colors.white),),
                            onPressed: () {
                              _showDialog();
                            },
                          ),
                        )
                      )
                    ],
                  ),
                )
              ],
            ),
            )
          ):Center(
            child: Container(
              child: CupertinoActivityIndicator(animating: true,),
            ),
          ),
        ),
      ],
    );
  }
                          
  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          backgroundColor: Colors.orange[100],
          title: Text("Thank You!"),
          content: Container(
            child: Text("Your feedback submitted Successfully!"),
          ),
          actions: <Widget>[
            FlatButton(child: Text("OK"), onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              editedPlace=EditedPlace(type, placeId, newName, newAddress, newPhone, isClosed,newLocation);
              FirebaseServices().updatePlaceEdit(editedPlace);
            },

        )
      ],
    );
      }
    );
  }

}