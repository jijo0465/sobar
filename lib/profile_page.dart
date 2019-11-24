// import 'dart:convert' show json;
import 'dart:io';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kudians/firebase_services.dart';
import 'package:kudians/phone_signin_page.dart';
import 'package:kudians/privacy_policy.dart';
import 'package:kudians/sobar_form_field.dart';
import 'package:kudians/user_cache.dart';
import 'package:kudians/users.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import "package:http/http.dart" as http;

// GoogleSignIn _googleSignIn = GoogleSignIn(
//   scopes: <String>[
//     'email',
//     'https://www.googleapis.com/auth/contacts.readonly',
//   ],
// );

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
  // GoogleSignInAccount _currentUser;
  // String _contactText;
  

  @override
  void initState() {
    if(UserCache().isCached()){
      sobarUser=UserCache().getUser();
      setAllfields(sobarUser);
            if(sobarUser!=null){
              setState(() {
              isLogged=true;
            });
            }
            
            firstName=sobarUser.firstName;
            lastName=sobarUser.lastName;
            sobarName=sobarUser.sobarName;
            phone=sobarUser.phoneNumber;
            photoUrl=sobarUser.photoUrl;
          }
          textEditingController=TextEditingController();
          // _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
          //   setState(() {
          //     _currentUser = account;
          //   });
          //   if (_currentUser != null) {
          //     _handleGetContact();
          //   }
          // });
          // _googleSignIn.signInSilently();
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
                      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.3, 
                      MediaQuery.of(context).size.height*0.07, 
                      MediaQuery.of(context).size.width*0.3, 50),
                      child: Container(
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.white70,
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
                             ):Container(),
                             !isLogged||photoUrl==''?Container():
                             Positioned(
                               top: 0,
                               right: 0,
                               child: Container(
                                 child: IconButton(
                                   icon: Icon(Icons.delete,color: Colors.white.withOpacity(0.8),size: 25,),
                                   onPressed: (){
                                     showDialog(
                                       context: context,
                                       builder: (BuildContext contect){
                                         return AlertDialog(
                                           title: Text('Delete Photo'),
                                           content: Text('Your profile photo will be removed permanently'),
                                           actions: <Widget>[
                                             FlatButton(
                                               child: Text('Cancel'),
                                               onPressed: (){
                                                 Navigator.of(context).pop();
                                               },
                                             ),
                                             FlatButton(
                                               child: Text('Ok'),
                                               onPressed: (){
                                                 UserCache().setPhotoUrl('');
                                                  setState(() {
                                                    photoUrl='';
                                                  });
                                                  Navigator.of(context).pop();
                                                  updateProfile();
                                               },
                                             )
                                           ],
                                         );
                                       }
                                     );
                                     
                                   },
                                 ),
                               ),
                             )
                             ]),
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
                      ):Column(
                        children: <Widget>[
                          Container(
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
                                  await Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context){
                                      return PhoneSignInPage();
                                    }
                                  ));
                                  if(UserCache().isCached()){
                                    sobarUser=UserCache().getUser();
                                    setAllfields(sobarUser);
                                      setState(() {
                                        isLogged=true;
                                      });
                                    }
                                },
                              ),
                          ),
                        //   Container(
                        //     child: RaisedButton(
                        //     onPressed: () {
                        //         _handleSignIn();
                        //     },
                        //     padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 3.0),
                        //     color: const Color(0xFFFFFFFF),
                        //     child: Container(
                        //         padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        //         child: Text( 
                        //           "Sign in with Google",
                        //           style: TextStyle(
                        //               color: Colors.grey,
                        //               fontWeight: FontWeight.bold),
                        //         )
                        //     ),
                        // )
                        //   )
                        ],
                      )
                          
                          ],
                        ),
                      ),
                    ),
                    Container(
                  alignment: Alignment.bottomCenter,
                  child: isLogged?Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        elevation: 3,
                        hoverElevation: 10,
                        hoverColor: Colors.black,
                        onPressed: isLogged?updateProfile:null,
                        color: Colors.black,
                        child: Text("Update",style: TextStyle(color:Colors.white,letterSpacing: 0.2)),
                      ),FlatButton(
                          child: Text("Logout",style: TextStyle(
                            letterSpacing: 0.2,
                            color: Colors.deepOrange.withOpacity(0.8)
                          ),),
                          onPressed: ()async {
                            await FirebaseAuth.instance.signOut();
                            // _handleSignOut();
                            setState(() {
                              isLogged=false; 
                            });
                            UserCache().clearUserCache();
                          },
                        )
                          ],
                        ):Container(),
                ),
                isLogged?Container(
                  // alignment: Alignment.topCenter,
                  child: FlatButton(
                    child: Text('Read our privacy policy',style: TextStyle(color: Colors.white24),),
                    onPressed: (){
                      _showPrivacyDialog();
                                          },
                                        ),
                                      ):Container()
                                  ],
                                );
                               }
                                // Future<void> setUser(String uid) async {
                                //       await FirebaseServices().getSobarUser(uid).then((value){
                                //         sobarUser=value;
                                //     });
                                //     if(sobarUser!=null){
                                //       UserCache().setUser(sobarUser);
                                //       setState(() {
                                //             isLogged=true;
                                //           });
                                //       }
                                // }
                                  
                                  void updateProfile() async {
                                    final success = SnackBar(content: Text('Updated Successfully!'), action: SnackBarAction(label: "OK",onPressed: (){},),);
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
                            
                              void setAllfields(SobarUsers sobarUser) {
                                firstName=sobarUser.firstName;
                                lastName=sobarUser.lastName;
                                phone=sobarUser.phoneNumber;
                                photoUrl=sobarUser.photoUrl;
                                sobarName=sobarUser.sobarName;
                              }
                      
                        void _showPrivacyDialog() {
                          TextStyle titleStyle=TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600
                          );
                          TextStyle subTitleStyle=TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500
                          );
                          TextStyle descStyle=TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 11
                          );
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context){
                              return Dialog(
                                
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  height: MediaQuery.of(context).size.height*0.7,
                                  width: MediaQuery.of(context).size.width*0.8,
                                  color: Colors.black87,
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        child: SingleChildScrollView(
                                          child: RichText(
                                            text: TextSpan(
                                              children: <TextSpan>[
                                                  TextSpan(text: PrivacyPolicy().titles[0],style: titleStyle),
                                                  TextSpan(text: PrivacyPolicy().descriptions[0],style: descStyle),
                                                  TextSpan(text: PrivacyPolicy().titles[1],style: subTitleStyle),
                                                  TextSpan(text: PrivacyPolicy().descriptions[1],style: descStyle),
                                                  TextSpan(text: PrivacyPolicy().titles[2],style: subTitleStyle),
                                                  TextSpan(text: PrivacyPolicy().descriptions[2],style: descStyle),
                                                  TextSpan(text: PrivacyPolicy().titles[3],style: subTitleStyle),
                                                  TextSpan(text: PrivacyPolicy().descriptions[3],style: descStyle),
                                                  TextSpan(text: PrivacyPolicy().titles[4],style: subTitleStyle),
                                                  TextSpan(text: PrivacyPolicy().descriptions[4],style: descStyle),
                                                  TextSpan(text: PrivacyPolicy().titles[5],style: subTitleStyle),
                                                  TextSpan(text: PrivacyPolicy().descriptions[5],style: descStyle),
                                                  TextSpan(text: PrivacyPolicy().titles[6],style: subTitleStyle),
                                                  TextSpan(text: PrivacyPolicy().descriptions[6],style: descStyle),
                                                  TextSpan(text: PrivacyPolicy().titles[7],style: subTitleStyle),
                                                  TextSpan(text: PrivacyPolicy().descriptions[7],style: descStyle),
                                                  TextSpan(text: PrivacyPolicy().titles[8],style: subTitleStyle),
                                                  TextSpan(text: PrivacyPolicy().descriptions[8],style: descStyle),
                                                  TextSpan(text: PrivacyPolicy().titles[9],style: subTitleStyle),
                                                  TextSpan(text: PrivacyPolicy().descriptions[9],style: descStyle),

                                              ]
                                            ),
                                            
                                            
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          icon: Icon(Icons.close,color: Colors.white70,),
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                backgroundColor: Colors.white,
                              );
                            }
                          );
                        }
  //         Future<void> _handleGetContact() async {
  //           setState(() {
  //             _contactText = "Loading contact info...";
  //           });
  //           final http.Response response = await http.get(
  //             'https://people.googleapis.com/v1/people/me/connections'
  //             '?requestMask.includeField=person.names',
  //             headers: await _currentUser.authHeaders,
  //           );
  //           if (response.statusCode != 200) {
  //             setState(() {
  //               _contactText = "People API gave a ${response.statusCode} "
  //                   "response. Check logs for details.";
  //             });
  //             print('People API ${response.statusCode} response: ${response.body}');
  //             return;
  //           }
  //           final Map<String, dynamic> data = json.decode(response.body);
  //           print(data);
  //           final String namedContact = _pickFirstNamedContact(data);
  //           setState(() {
  //             if (namedContact != null) {
  //               _contactText = "I see you know $namedContact!";
  //             } else {
  //               _contactText = "No contacts to display.";
  //             }
  //           });
  //         }

  //   String _pickFirstNamedContact(Map<String, dynamic> data) {
  //   final List<dynamic> connections = data['connections'];
  //   final Map<String, dynamic> contact = connections?.firstWhere(
  //     (dynamic contact) => contact['names'] != null,
  //     orElse: () => null,
  //   );
  //   if (contact != null) {
  //     final Map<String, dynamic> name = contact['names'].firstWhere(
  //       (dynamic name) => name['displayName'] != null,
  //       orElse: () => null,
  //     );
  //     if (name != null) {
  //       return name['displayName'];
  //     }
  //   }
  //   return null;
  // }

  // Future<void> _handleSignIn() async {
  //   try {
  //     await _googleSignIn.signIn();
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  // Future<void> _handleSignOut() async {
  //   _googleSignIn.disconnect();
  // }
}