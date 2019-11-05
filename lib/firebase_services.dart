import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kudians/edited_place.dart';
import 'package:kudians/holidays.dart';
import 'package:kudians/kuppi.dart';
import 'package:kudians/place_data.dart';
import 'package:kudians/review_data.dart';
import 'package:kudians/users.dart';
import 'package:uuid/uuid.dart';

import 'bars.dart';

class FirebaseServices{
  Firestore firestore;
  List<Bars> allBars;
  List<PlaceData> allBevco;
  FirebaseServices(){
    firestore=Firestore.instance;
    allBars=List<Bars>();
    allBevco=new List<PlaceData>();
  }

  Future<List<Bars>> getAllBars() async {
    Bars bars;
    await firestore.collection("bars").getDocuments().then((docs){
      if(docs.documents.isNotEmpty){
          for(int i=0;i<docs.documents.length;i++){
            String barId=docs.documents[i].data['bars_id'];
            LatLng barLocation=LatLng((docs.documents[i].data['bar_latlng']).latitude,(docs.documents[i].data['bar_latlng']).longitude);
            String barName=docs.documents[i].data['bar_name'];
            String placeId=docs.documents[i].data['place_id'];
            bars=Bars(barId, barLocation, barName,placeId);
            allBars.add(bars);
          }
        }
    });
    return allBars;
  }

  Future<List<PlaceData>> getAllBevco() async {
    PlaceData bevco;
    List<PlaceData> allBevco=List<PlaceData>();
    await firestore.collection("kerala_bevco").getDocuments().then((docs){
      if(docs.documents.isNotEmpty){
          for(int i=0;i<docs.documents.length;i++){
            List<dynamic> review=new List<dynamic>();
            List<int> photoIds=new List<int>();
            var data=docs.documents[i].data;
            int bevcoId=data['bevco_id'];
            LatLng bevcoLocation=LatLng(data['bevco_lat'],data['bevco_lng']);
            String bevcoName=data['bevco_name'];
            String bevcoAddress=data['bevco_address'];
            double bevcoRating=data['bevco_rating'];
            int bevcoTotalRating=data['bevco_total_rating'];
            String bevcoPlaceId=data['bevco_placeId'];
            String bevcoDistrict=data['bevco_district'];
            String bevcoPhone="";
            if(data.containsKey('bevco_phone')){
              bevcoPhone=data['bevco_phone'];
            }
            if(data.containsKey('bevco_photo_ids')){
              photoIds=data['bevco_photo_ids'].cast<int>();
            }
            
            review=data['reviews'];
            
            List<Map<String,dynamic>> reviews=List<Map<String,dynamic>>();
            if(review!=null){
              for(int i=0;i<review.length;i++){
                Map<String,dynamic> rev= Map<String, dynamic>.from(review[i]);
                reviews.add(rev);
              }
            }
            bevco=PlaceData(bevcoId, bevcoLocation, bevcoName, bevcoAddress, bevcoRating, bevcoTotalRating, bevcoPlaceId, bevcoDistrict, bevcoPhone,reviews,photoIds);
            allBevco.add(bevco);
          }
        }
    });
    return allBevco;
  }

  Future<List<PlaceData>> getAllToddy() async {
    PlaceData toddy;
    List<PlaceData> alltoddy=List<PlaceData>();
    await firestore.collection("kerala_toddy_shop").getDocuments().then((docs){
      if(docs.documents.isNotEmpty){
          for(int i=0;i<docs.documents.length;i++){
            List<dynamic> review=new List<dynamic>();
            List<int> photoIds=new List<int>();
            var data=docs.documents[i].data;
            int toddyId=data['toddy_shop_id'];
            LatLng toddyLocation=LatLng(data['toddy_lat'],data['toddy_lng']);
            String toddyName=data['toddy_name'];
            String toddyAddress=data['toddy_address'];
            double toddyRating=data['toddy_rating'];
            int toddyTotalRating=data['toddy_total_rating'];
            String toddyPlaceId=data['toddy_placeId'];
            String toddyDistrict=data['toddy_district'];
            String toddyPhone="";
            if(data.containsKey('toddy_phone')){
              toddyPhone=data['toddy_phone'];
            }
            if(data.containsKey('toddy_photo_ids')){
              photoIds=data['toddy_photo_ids'].cast<int>();
            }
            
            review=data['toddy_reviews'];
            
            List<Map<String,dynamic>> reviews=List<Map<String,dynamic>>();
            if(review!=null){
              for(int i=0;i<review.length;i++){
                Map<String,dynamic> rev= Map<String, dynamic>.from(review[i]);
                reviews.add(rev);
              }
            }
            toddy=PlaceData(toddyId, toddyLocation, toddyName, toddyAddress, toddyRating, toddyTotalRating, toddyPlaceId, toddyDistrict, toddyPhone,reviews,photoIds);
            alltoddy.add(toddy);
          }
        }
    });
    return alltoddy;
  }
  void updatePlaceEdit(EditedPlace place){
    String collection="edited_"+place.database;
    String document=place.database+'_'+place.placeId.toString();
    DocumentReference documentReference=firestore.collection(collection).document(document);
    documentReference.get().then((doc){
      if(doc.exists){
        documentReference.updateData({'edit':FieldValue.arrayUnion(place.toMapList())});
      }else{
        documentReference.setData({'edit':FieldValue.arrayUnion(place.toMapList())});
      }
    });
  }

  void addReview(ReviewData reviewData) async{
    String collection;
    if(reviewData.type=='bevco'){
      collection='kerala_bevco';
    }else if (reviewData.type=='toddy'){
      collection='kerala_toddy_shop';
    }
    String document="kerala_"+reviewData.type+"_"+reviewData.placeId.toString();
    DocumentReference documentReference=firestore.collection(collection).document(document);
    var storageImageRef=FirebaseStorage.instance.ref().child('sobar_'+reviewData.type);
    reviewData.photoRefs=List<String>();
    reviewData.photos.forEach((f) async {
      var uuid = Uuid();
      String photoRef=uuid.v1();
      final StorageReference _ref = storageImageRef.child(photoRef);
      _ref.putFile(File(f));
      reviewData.photoRefs.add(photoRef);
    });
    documentReference.get().then((doc){
      if(doc.exists){
        documentReference.updateData({'sobar_reviews':FieldValue.arrayUnion(reviewData.toMapList())});
      }else{
        documentReference.setData({'sobar_reviews':FieldValue.arrayUnion(reviewData.toMapList())});
      }
    });
  }
  Future<SobarUsers> updateProfile(SobarUsers sobarUser)async{
    String collection="sobar_users";
    String document=sobarUser.userId;
    DocumentReference docRef=firestore.collection(collection).document(document);
    docRef.get().then((doc){
      if(doc.exists){
        docRef.updateData(sobarUser.toMap());
      }else{
        docRef.setData(sobarUser.toMap());
      }
    });
    return getSobarUser(sobarUser.userId);
  }

  Future<String> uploadDp(String filePath,String uid)async{
    String photoUrl='';
    final StorageReference _ref=FirebaseStorage.instance.ref().child('user_dp').child(uid);
    StorageUploadTask uploadTask =_ref.putFile(File(filePath));
    final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
    print('File Uploaded');
    DocumentReference docRef=firestore.collection('sobar_users').document(uid);
    photoUrl = await downloadUrl.ref.getDownloadURL();
    docRef.get().then((doc){
      if(doc.exists){
        docRef.updateData({'photo_url':photoUrl});
      }
    });
    return photoUrl;

  }

  Future<SobarUsers> getSobarUser(String uid)async{
    SobarUsers sobarUsers=SobarUsers(uid);
    FirebaseUser user= await FirebaseAuth.instance.currentUser();
    DocumentReference documentReference=firestore.collection('sobar_users').document(uid);
    await documentReference.get().then((doc) {
      if(!doc.exists){
        documentReference.setData({'user_id':uid,'phone_number':user.phoneNumber});
      }
      sobarUsers.firstName=doc.data['first_name']==null?'':doc.data['first_name'];
      sobarUsers.lastName=doc.data['last_name']==null?'':doc.data['last_name'];
      sobarUsers.sobarName=doc.data['sobar_name']==null?'':doc.data['sobar_name'];
      sobarUsers.phoneNumber=doc.data['phone_number']==null?'':doc.data['phone_number'];
      sobarUsers.photoUrl=doc.data['photo_url']==null?'':doc.data['photo_url'];
    });
    return sobarUsers;
  }

    Future<List<Holidays>> getAllHolidays()async{
      DateTime today=DateTime.now();
      List<Holidays> holidays=List<Holidays>();
      Holidays holiday;
      await firestore.collection("kerala_holidays").getDocuments().then((docs){
        if(docs.documents.isNotEmpty){
            for(int i=0;i<docs.documents.length;i++){
              var data=docs.documents[i].data;
              if(today.isBefore(data['date'].toDate())){
                holiday=Holidays(docs.documents[i].documentID, data['date'].toDate(), data['reason']);
                holidays.add(holiday);
              }
            }
        }
      });
     return holidays;
    }

    Future<List<Kuppi>> getAllKuppi()async{
      List<Kuppi> kuppiList=List<Kuppi>();
      Kuppi kuppi;
      await firestore.collection("kerala_bevco_price").getDocuments().then((docs){
        if(docs.documents.isNotEmpty){
            for(int i=0;i<docs.documents.length;i++){
              var data=docs.documents[i].data;
              int price= data['price'];
              String name=data['name'];
              int volume=data['volume'];
              String category=data['category'];
              String size=data['size'];
              kuppi = Kuppi(name,price,category,size,volume);
              kuppiList.add(kuppi);
            }
        }
      });
     return kuppiList;
    }
}