import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kudians/bottom_sheet_text.dart';

class Rating extends StatelessWidget{
  final double rating;
  final int totalRated;

  const Rating({Key key, this.rating,this.totalRated}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        BottomSheetText(text: '('+rating.toString()+')'),
        RatingBarIndicator(
          rating: rating,
          itemBuilder: (context, index) => Icon(
            Icons.star,
            color: Colors.deepOrange[800],
          ),
          itemCount: 5,
          itemSize: 20.0,
          direction: Axis.horizontal,
    ),
        BottomSheetText(text:'('+totalRated.toString()+')')
      ],
    );
  }

}

