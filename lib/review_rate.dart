import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kudians/phone_signin_page.dart';
import 'package:kudians/review_data.dart';
import 'package:kudians/review_page.dart';
import 'package:kudians/user_cache.dart';

class ReviewRate extends StatefulWidget{
  final String placeName;
  final int placeId;
  final String placeType;
  final bool isUserReviewed;
  final double rating;
  final ValueChanged<ReviewData> isReviwed;
  const ReviewRate({Key key, @required this.placeName,@required this.placeId, @required this.placeType, this.isUserReviewed, this.rating, this.isReviwed}) : super(key: key);

  @override
  _ReviewRateState createState() => _ReviewRateState();
}

class _ReviewRateState extends State<ReviewRate> {
  bool isReviewed=false;

  @override
  void initState() {
    isReviewed=widget.isUserReviewed;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
          ),
          !widget.isUserReviewed?Text("Share your Experience"):Container(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: !widget.isUserReviewed? RatingBar(
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
                ReviewData review = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                return ReviewPage(
                  placeId: widget.placeId,
                  placeName: widget.placeName,
                  rating: rating.toInt(),
                  placeType: widget.placeType,
                );
              }));
              if(review!=null){
                widget.isReviwed(review);
              }else{
                widget.isReviwed(null);
              }
              }
            }
              
    ):RatingBarIndicator(
      rating: widget.rating,
      unratedColor: Colors.white,
      alpha: 100,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.deepOrange,
      ),
    ),
          )
        ],
      ));
  }
}