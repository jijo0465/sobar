import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kudians/bottom_sheet_text.dart';
import 'package:kudians/bottom_sheet_title.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomSheetAddressPhone extends StatelessWidget{
  final String address;
  final String phone;
  final LatLng latLng;
  final String placeId;
  final String name;
  const BottomSheetAddressPhone({Key key, this.address, this.phone, this.latLng, this.placeId, this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    
    return Container(
      padding: EdgeInsets.fromLTRB(12, 12, 0, 8),
      child: Column(
        children: <Widget>[
           BottomSheetTitle(title:"Address"),
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 0.6*MediaQuery.of(context).size.width,
                      child: BottomSheetText(text:address),
                    ),
                    
                    Container(
                      width: 0.3*MediaQuery.of(context).size.width,
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () async {
                          String mapUrl;
                          double latitude=latLng.latitude;
                          double longitude=latLng.longitude;
                          if(placeId==null||placeId==''){
                            mapUrl=mapUrl ='https://www.google.com/maps/search/?api=1&  query=$latitude,$longitude';
                          }
                          mapUrl ='https://www.google.com/maps/dir/?api=1&destination=$name&destination_place_id=$placeId';
                          await launch(mapUrl);
                        },
                        icon: Icon(Icons.directions,color: Colors.orange[900]),
                      ),
                    )
                  ],
                ),
              ),
             Padding(
               padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
             ),
              BottomSheetTitle(title:"Phone"),
              
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 0.6*MediaQuery.of(context).size.width,
                      child: BottomSheetText(text:phone),
                    ),
                    Container(
                      width: 0.3*MediaQuery.of(context).size.width,
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () async {
                          String tel='tel:$phone';
                          await launch(tel);
                        },
                        icon: Icon(Icons.phone,color: Colors.orange[900],),
                      ),
                    )
                  ],
                ),
              )
        ],
      ),
    );
  }

}