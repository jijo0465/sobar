import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kudians/phone_signin_page.dart';
import 'package:kudians/review_page.dart';
import 'package:kudians/user_cache.dart';

class ReviewRate extends StatelessWidget{
  final String placeName;
  final int placeId;
  final String placeType;

  const ReviewRate({Key key, @required this.placeName,@required this.placeId, @required this.placeType}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
          ),
          Text("Share your Experience"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RatingBar(
            initialRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: false,
            unratedColor: Colors.white,
            alpha: 100,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.deepOrange,
            ),
            onRatingUpdate: (rating) async {
              
              if(!UserCache().isCached()){
                await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                  return PhoneSignInPage();
              }));
              }
              if(UserCache().isCached()){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                return ReviewPage(
                  placeId: placeId,
                  placeName: placeName,
                  rating: rating.toInt(),
                  placeType: placeType,
                );
              }));
              }
            }
              
    ),
          )
        ],
      ));
  }

}