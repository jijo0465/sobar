import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kudians/firebase_services.dart';
import 'package:kudians/phone_signin_page.dart';
import 'package:kudians/sobar_form_field.dart';
import 'package:kudians/user_cache.dart';
import 'package:kudians/users.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ProfilePage extends StatefulWidget{
  const ProfilePage();
  @override
  State<StatefulWidget> createState() {
    return _ProfilePage();
  }
}
class _ProfilePage extends State<ProfilePage>{
  FirebaseUser user;
  TextEditingController textEditingController;
  bool isLogged=false;
  String firstName='';
  String lastName='';
  String sobarName='';
  String phone='';
  List<Asset> imageList;
  List<String> urls;
  String photoUrl='';
  File dp;
  SobarUsers sobarUser;
  String filePath;

  @override
  void initState() {
    if(UserCache().isCached()){
      print("It is Here");
      setState(() {
        isLogged=true;
        sobarUser=UserCache().getUser();
      });
      firstName=sobarUser.firstName;
      lastName=sobarUser.lastName;
      sobarName=sobarUser.sobarName;
      phone=sobarUser.phoneNumber;
      photoUrl=sobarUser.photoUrl;
    }else{
      FirebaseAuth.instance.currentUser().then((value){
        if(value!=null){
          setUser(value.uid);
        }
      });
    }
    textEditingController=TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 60),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                CircleAvatar(
                  radius: 80,
                  backgroundImage: !isLogged||photoUrl==''?AssetImage("assets/user.png"): NetworkImage(photoUrl),
                 ),
                 Positioned(
                   child: FlatButton(
                      child: Text("Change DP", style: TextStyle(color: Colors.white),), onPressed: () async{
                      imageList=await MultiImagePicker.pickImages(
                        maxImages:1,
                        enableCamera: true
                      );
                      urls=List<String>();
                      for ( var imageFile in imageList) {
                        urls.add(await imageFile.filePath);
                      }
                      if(imageList.isNotEmpty){
                        String url;
                        filePath=urls.first;
                        url=await FirebaseServices().uploadDp(filePath,sobarUser.userId);
                        setState(() {
                          photoUrl=url; 
                        });
                        UserCache().setPhotoUrl(photoUrl);
                      }
                    }),
                    bottom: 2,
                 )
              ],
            )
          ),
          !isLogged?Container(child: Icon(Icons.local_bar,size: 60,color: Colors.white,)):
          SobarFormField(
            label: 'First Name',
            maxLines: 1, enabled: true,
            initialValue: sobarUser.firstName,
            onChanged: (value){
              firstName=value;
            },
          ),
          !isLogged?Container():
          SobarFormField(
            label: 'Last Name',
            initialValue: sobarUser.lastName,
            maxLines: 1, enabled: true,
            onChanged: (value){
              lastName=value;
            },
          ),
          !isLogged?Container():
          SobarFormField(
            label: 'Sobar Name',
            initialValue: sobarUser.sobarName,
            maxLines: 1, enabled: true,
            onChanged: (value){
              sobarName=value;
            },
          ),
          !isLogged?Container():
          SobarFormField(
            label: 'Phone',
            initialValue: sobarUser.phoneNumber,
            maxLines: 1, enabled: false,
            onChanged: (value){
              phone=value;
            }),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                isLogged?
                RaisedButton(
                  elevation: 6,
                  hoverElevation: 10,
                  hoverColor: Colors.deepOrange,
                  onPressed: isLogged?updateProfile:null,
                  color: Colors.orange.withOpacity(0.5),
                  child: Text("Save",style: TextStyle(color:Colors.white,)),
                ):Container(),isLogged?FlatButton(
                    child: Text("Logout",style: TextStyle(
                      color: Colors.white
                    ),),
                    onPressed: ()async {
                      await FirebaseAuth.instance.signOut();
                      setState(() {
                        isLogged=false; 
                      });
                      UserCache().clearUserCache();
                      print(UserCache().isCached());
                    },
                  ):FlatButton(
                    child: Text('Login',style: TextStyle(
                      color: Colors.white
                    ),),
                    onPressed: () async {
                      String userId=await Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context){
                          return PhoneSignInPage();
                        }
                      ));
                      if(userId!=null){
                        setUser(userId);
                        }
                    },
                  ),
                    ],
                  ),
          )
              ],
            ),
          )
          )
          ;
        }
        Future<void> setUser(String uid) async {
              await FirebaseServices().getSobarUser(uid).then((value){
                sobarUser=value;
            });
            if(sobarUser!=null){
              UserCache().setUser(sobarUser);
              setState(() {
                    isLogged=true;
                  });
              }
        }
      
      void updateProfile() async {
        final success = SnackBar(content: Text('Saved Successfully!'), action: SnackBarAction(label: "OK",onPressed: (){},),);
        final fail=SnackBar(content: Text("Something went Wrong!"),);
        SobarUsers _sobarUser=SobarUsers(sobarUser.userId);
        SobarUsers updatedUser;
        _sobarUser.firstName=firstName.trim();
        _sobarUser.lastName=lastName.trim();
        _sobarUser.phoneNumber=sobarUser.phoneNumber;
        _sobarUser.sobarName=sobarName.trim();
        try{
          updatedUser=await FirebaseServices().updateProfile(_sobarUser);
          setState(() {
           sobarUser=updatedUser; 
          });
          UserCache().setUser(sobarUser);
        }catch(e) {
          Scaffold.of(context).showSnackBar(fail);
        }
          Scaffold.of(context).showSnackBar(success);
      }
}