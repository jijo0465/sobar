import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kudians/bottom_sheet_text.dart';
import 'package:kudians/bottom_sheet_title.dart';
import 'package:kudians/firebase_services.dart';
import 'package:kudians/photo_list.dart';
import 'package:kudians/review_data.dart';
import 'package:kudians/user_cache.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ReviewPage extends StatefulWidget{
  final String placeName;
  final int rating;
  final int placeId;
  final String placeType;
  const ReviewPage({Key key, this.placeName, this.rating, this.placeId, @required this.placeType}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ReviewPage();
  }
}

class _ReviewPage extends State<ReviewPage>{
  List<String> urlList;
  String placeType;
  String review;
  int rating;
  ReviewData reviewData;
  List<Asset> imageList;
  int placeId;
  List<String> urls;
  
  @override
  void initState() {
        super.initState();
        urlList=List<String>();
        rating=widget.rating;
        placeType=widget.placeType;
        placeId=widget.placeId;
        urls=List<String>();
      }
        @override
      Widget build(BuildContext context) {
        return Scaffold(
          resizeToAvoidBottomPadding: true,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(widget.placeName),
            backgroundColor: Colors.orange[300],
          ),
          backgroundColor: Colors.orange[200],
          body: Container(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 0.08*MediaQuery.of(context).size.height,
                              child: Icon(Icons.supervised_user_circle,size: 40,),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  BottomSheetTitle(title:UserCache().getUser().sobarName),
                                  BottomSheetText(text:"Posting Publicly")
                                ],
                              ),
                              height: 0.08*MediaQuery.of(context).size.height
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child:Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RatingBar(
                        initialRating: widget.rating.toDouble(),
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        unratedColor: Colors.white,
                        alpha: 100,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 12.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.deepOrange,
                        ),
                        onRatingUpdate: (value) {
                          rating=value.toInt();
                        }),
                      )
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                      child: TextField(
                        minLines: 1,
                        maxLines: 5,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Share your Experience..."
                        ),
                        onChanged: (value){
                          review=value;
                        },
                      ),
                    ),
                    (urlList.length>0)?PhotoList(count: urlList.length,url: urlList,title: widget.placeName, source: "storage",):Container(),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        RaisedButton(
                        color: Colors.orange[300],
                        child: Text("Upload Photos"),
                        onPressed: ()async{
                          imageList=await MultiImagePicker.pickImages(
                            maxImages:10,
                            enableCamera: true
                          );
                          
                          for ( var imageFile in imageList) {
                            urls.add(await imageFile.filePath);
                          }
                          setState(() {
                           urlList=urls; 
                          });
                        },
                      ),
                      ],),
    
                        
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.fromLTRB(12, 8, 12, 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: SizedBox(
                          height: 50,
                          child: RaisedButton(
                            color: Colors.orange[400],
                            child:Text("Submit"),
                            onPressed: () {
                              _showDialog();
                            },
                          ),
                        )
                      )],
                ),
              ),
            ),
        ));
      }
        void _showDialog() {
        showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              backgroundColor: Colors.orange[100],
              title: Text("Success"),
              content: Container(
                child: Text("Your review will be verified and avilable soon!"),
              ),
              actions: <Widget>[
                FlatButton(child: Text("Cancel"), onPressed: () {
                  Navigator.of(context).pop();
                }),
                FlatButton(child: Text("OK"), onPressed: () {
                  reviewData=ReviewData(UserCache().getUser().userId);
                  reviewData.review=review;
                  reviewData.rating=rating;
                  reviewData.type=placeType;
                  reviewData.photos=urlList;
                  reviewData.placeId=placeId;
                  reviewData.authorName=UserCache().getUser().sobarName;
                  reviewData.profilePhotoUrl=UserCache().getUser().photoUrl;
                  FirebaseServices().addReview(reviewData);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
    
            )
          ],
        );
          }
        );
      }
}