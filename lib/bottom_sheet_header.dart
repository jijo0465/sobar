import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kudians/bottom_sheet_text.dart';
import 'package:kudians/bottom_sheet_title.dart';
import 'package:kudians/rating.dart';

class BottomSheetHeader extends StatelessWidget{
  final String title;
  final double rating;
  final String type;
  final int totalRated;
  final int bottState;

  const BottomSheetHeader({Key key, this.title, this.rating, this.type, this.totalRated, this.bottState}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.fromLTRB(12, 12, 0, 12),
      padding: EdgeInsets.fromLTRB(12, 12, 0, 8),
      color: Colors.orange[300],
      child: AnimatedCrossFade(
          firstChild: Container(
            child: Column(
              children: <Widget>[
                Container(
                  child: Icon(Icons.arrow_drop_up)),
                BottomSheetTitle(title:title),
                Rating(rating:rating,totalRated: totalRated),
                BottomSheetText(text:type),
              ],
            ),
          ),
          secondChild:Container(child: Column(
            children: <Widget>[
              Icon(Icons.arrow_drop_down),
              BottomSheetTitle(title:title),
            ],
          )),
          duration: const Duration(milliseconds: 210),
          crossFadeState: (bottState!=1) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      ),

    );
  }

}