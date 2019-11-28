import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kudians/firebase_services.dart';
import 'package:kudians/my_flutter_app_icons.dart';
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
  String response='none';
  
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
                title: Container(
                  child: Text(widget.placeName,style: TextStyle(color: Colors.white,fontSize: 17),)),
                backgroundColor: Colors.transparent,
                elevation: 0,
                
              ),
              backgroundColor: Colors.transparent,
              body: Container(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 8,right: 8,bottom: 8),
                          child: Divider(
                            color: Colors.white30,
                            height: 0,
                          ),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: 0.08*MediaQuery.of(context).size.height,
                                  child: Icon(MyFlutterApp.user_1,size: 40,color: Colors.white60,),
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(UserCache().getUser().sobarName,style: TextStyle(
                                        color: Colors.white
                                      ),),
                                      Text("Posting Publicly",style: TextStyle(
                                        color: Colors.white.withOpacity(0.6)))
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
                        
                        ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                              child: TextField(
                                minLines: 1,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9)
                                ),
                                maxLines: 5,
                                autofocus: true,
                                cursorColor: Colors.deepOrange[400],
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white54),
                                    borderRadius: BorderRadius.circular(10.0),),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white30),
                                    borderRadius: BorderRadius.circular(10.0),),
                                  hintText: "Share your Experience...",
                                  hintStyle: TextStyle(
                                    fontSize: 17,
                                            color: Colors.white.withOpacity(0.6))
                                ),
                                onChanged: (value){
                                  review=value;
                                },
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 8,right: 8),
                          child: Divider(
                            color: Colors.white30,
                            height: 0,
                          ),
                        ),
                        (urlList.length>0)?PhotoList(count: urlList.length,url: urlList, source: "storage",):Container(),
                        Container(
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Add Photos',style:TextStyle(color: Colors.white)),
                              Padding(padding: EdgeInsets.only(left: 12),),
                              Icon(Icons.add_a_photo,color: Colors.white,size: 20,),
                            ],
                          ),
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
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 8,right: 8),
                          width: double.infinity,
                          height: 50,
                            child: RaisedButton(
                              elevation: 10,
                              hoverColor: Colors.black12,
                              color: Colors.black,
                              child: Text("Submit",style: TextStyle(color:Colors.white,letterSpacing: 0.3)),
                              onPressed: () async {
                                _showDialog();
                              },
                            ),
                      )],
                    ),
                  ),
                ),
            )),
          ],
        );
      }
        void _showDialog() {
        showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              backgroundColor: Colors.orange[100],
              title: Text("Confirm?"),
              content: Container(
                child: Text("Once verified, Your review will be available to public"),
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
                  reviewData.reviewTime=DateTime.now();
                  reviewData.authorName=UserCache().getUser().sobarName;
                  reviewData.profilePhotoUrl=UserCache().getUser().photoUrl;
                  try{
                    FirebaseServices().addReview(reviewData);
                    Navigator.of(context).pop();
                    Navigator.pop(context,reviewData);
                  }catch(e){
                    Navigator.of(context).pop();
                    Navigator.pop(context,reviewData);
                  }
                  
                },
    
            )
          ],
        );
          }
        );
      }
}