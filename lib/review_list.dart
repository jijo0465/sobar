import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kudians/bottom_sheet_text.dart';
import 'package:kudians/bottom_sheet_title.dart';
class ReviewList extends StatelessWidget{
  final List<Map<String,dynamic>> reviews;
  final Map<String,dynamic> userReview;
  

  const ReviewList({Key key, this.reviews, this.userReview}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, idx) => ListTile(
          contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 0),
            title:Row(
              crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: reviews[idx]['profile_photo_url']==''?AssetImage('assets/user.png'):
                            NetworkImage(
                              reviews[idx]['profile_photo_url']
                                )
                        )
                    )),
                    ),
                    Expanded(
                      flex: 15,
                      child: Container(
                      padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            child: BottomSheetTitle(title:reviews[idx]['author_name'])),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                RatingBarIndicator(
                                  rating: reviews[idx]['rating'].toDouble(),
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.deepOrange[800],
                                  ),
                                  itemCount: 5,
                                  itemSize: 17.0,
                                  direction: Axis.horizontal,
                                ),
                                 Container(
                                   child: BottomSheetText(text:reviews[idx]['relative_time_description'])),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    )
                    
                  ],
                ),
            subtitle: Padding(
              padding: const EdgeInsets.fromLTRB(15, 2, 12, 0),
              child: reviews[idx]['text']!=''?Text('"'+reviews[idx]['text']+'"',style: TextStyle(color: Colors.grey[900]),):Text(''),
            ),
        ),
        childCount: reviews.length,
      ),
    );
  }

}