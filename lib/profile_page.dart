import 'dart:io';
import 'package:keyboard_avoider/keyboard_avoider.dart';
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
  ScrollController _scrollController=ScrollController();
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
    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height*0.77,
          child: KeyboardAvoider(
            autoScroll: true,
          child: ListView(
            controller: _scrollController,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 65, 0, 50),
                child: Container(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: !isLogged||photoUrl==''?AssetImage("assets/user.png"): NetworkImage(photoUrl),
                       ),isLogged?
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
                       ):Container()]),
                )),
                isLogged?
                Padding(
                  padding: EdgeInsets.only(left: 12,right: 12),
                  child: Column(
                    children: <Widget>[
                      SobarFormField(
                      label: 'First Name',
                      maxLines: 1, enabled: true,
                      initialValue: sobarUser.firstName,
                      onChanged: (value){
                        firstName=value;
                      },
                    ),
                    SobarFormField(
                      label: 'Last Name',
                      initialValue: sobarUser.lastName,
                      maxLines: 1, enabled: true,
                      onChanged: (value){
                        lastName=value;
                      },
                    ),
                    SobarFormField(
                      label: 'Sobar Name',
                      initialValue: sobarUser.sobarName,
                      maxLines: 1, enabled: true,
                      onChanged: (value){
                        sobarName=value;
                      },
                    ),
                    SobarFormField(
                      label: 'Phone',
                      initialValue: sobarUser.phoneNumber,
                      maxLines: 1, enabled: false,
                      onChanged: (value){
                        phone=value;
                      })
                    ],
                  ),
                ):Container(
                  child: FlatButton(
                    color: Colors.transparent,
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.deepOrange.withOpacity(0.6),
                    textColor: Colors.white,
                      child: Text('Login',style: TextStyle(
                        fontSize: 20,
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
                )
                    
                    ],
                  ),
                ),
              ),
              Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 75),
              child: isLogged?Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    elevation: 6,
                    hoverElevation: 10,
                    hoverColor: Colors.deepOrange[800],
                    onPressed: isLogged?updateProfile:null,
                    color: Colors.deepOrange,
                    child: Text("Save",style: TextStyle(color:Colors.white,letterSpacing: 0.2)),
                  ),FlatButton(
                      child: Text("Logout",style: TextStyle(
                        letterSpacing: 0.2,
                        color: Colors.deepOrange
                      ),),
                      onPressed: ()async {
                        await FirebaseAuth.instance.signOut();
                        setState(() {
                          isLogged=false; 
                        });
                        UserCache().clearUserCache();
                      },
                    )
                      ],
                    ):Container(),
            ),
          )
      ],
    );
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