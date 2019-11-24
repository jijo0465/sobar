import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kudians/firebase_services.dart';
import 'package:kudians/loading.dart';
import 'package:kudians/my_flutter_app_icons.dart';
import 'package:kudians/user_cache.dart';
import 'package:kudians/users.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
class PhoneSignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PhoneSignInSectionState();
}

class _PhoneSignInSectionState extends State<PhoneSignInPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  final TextEditingController _sobarNameController = TextEditingController();
final FirebaseAuth _auth = FirebaseAuth.instance;
  String _message = '';
  bool isPreviouslyLogged=false;
  String phone='';
  String sobarName='';
  String errorMessage='';
  String _verificationId;
  bool isSobarNameSet=false;
  SobarUsers sobarUser;
  FirebaseUser firebaseUser;
  bool isLogged=false;
  bool isLoading=false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _sobarNameFormKey = GlobalKey<FormState>();
  bool isVerified=false;
  // BannerAd bannerAd;
  //   BannerAd buildBannerAd(){
  //     return BannerAd(
  //       adUnitId: 'ca-app-pub-7846270136949123/2803648150',
  //       size: AdSize.banner,
  //       listener: (MobileAdEvent event){
  //       }
  //     );
  //   }
@override
  void initState() {
    // bannerAd = buildBannerAd()..load();
    super.initState();
  }

  @override
  void dispose() {
    // bannerAd?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // bannerAd..load()..show();
    return isLoading?Loading(): Stack(
      children: <Widget>[
        Container(
              width: double.infinity,
              height: double.infinity,
              child: FittedBox(
                fit:  BoxFit.fill,
                child: Image.asset('assets/background.png')),
            ),
        WillPopScope(
              child: Scaffold(
            resizeToAvoidBottomPadding: false,
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              bottomOpacity: 0.0,
              iconTheme: IconThemeData(color: Colors.white),
              title: Text('Sobar Sign Up',style: TextStyle(
                color: Colors.white
              ),),
              
            ),
          body:ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4,sigmaY: 4),
              child: Container(
                height: MediaQuery.of(context).size.height,
                    child: isVerified&&!isLogged?Container(
                      child: Column(
                        children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.3),
                          child: PinCodeTextField(
                            autofocus: true,
                            controller: _smsController,
                            hideCharacter: false,
                            highlight: true,
                            highlightColor: Colors.white,
                            defaultBorderColor: Colors.black,
                            hasTextBorderColor: Colors.deepOrange,
                            maxLength: 6,
                            onDone: (text){
                              
                            },
                          pinCodeTextFieldLayoutType: PinCodeTextFieldLayoutType.AUTO_ADJUST_WIDTH,
                          pinBoxDecoration: ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                          pinTextStyle: TextStyle(fontSize: 25.0,color: Colors.white),
                          pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.scalingTransition,
                          pinTextAnimatedSwitcherDuration: Duration(milliseconds: 150),
                          pinBoxWidth: 50,
                          pinBoxHeight: 40,
                          wrapAlignment: WrapAlignment.end,
                          
                      ),
                        ),
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              elevation: 6,
                              color: Colors.deepOrange,
                              textColor: Colors.white,
                              child: Text("Verify",style: TextStyle(letterSpacing: 0.3  ),), onPressed: () {
                                _signInWithPhoneNumber();
                              },
                            ),
                            FlatButton(
                              child: Text("Cancel", style: TextStyle(
                                letterSpacing: 0.3,
                                color: Colors.white
                              ),),
                              onPressed: (){
                                setState(() {
                                 isVerified=false; 
                                });
                              },
                            )
                          ],
                        ),
                      )
                        ],
                      ),
                    ):AnimatedCrossFade(
                      duration: const Duration(milliseconds: 210),
                      crossFadeState: isLogged ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      firstChild: Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.2,left: 16,right: 16),
                      child: Form(
                        key: _formKey,
                          child: Column(children: <Widget>[
                          
                          SizedBox(
                            height: 12,
                          ),
                          Container(
                            child: Theme(
                              data: Theme.of(context)
                                            .copyWith(primaryColor: Colors.deepOrange,),
                                child: TextFormField(
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    letterSpacing: 3
                                    ),
                                onChanged: (value){
                                  phone=value;
                                },
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                prefixText: ' ',
                                prefixIcon: Icon(CupertinoIcons.phone_solid),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white30, width: 0.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 0.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red.withOpacity(0.3), width: 0.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red.withOpacity(0.6), width: 0.0),
                                ),
                                labelText: 'Phone',
                                labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    letterSpacing: 3
                                    ),
                                contentPadding: EdgeInsets.all(0),
                                helperStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.8)
                                )
                              ),
                              cursorColor: Colors.deepOrange,
                              controller: _phoneNumberController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              maxLengthEnforced: true,
                              validator: (value){
                                  String patttern = r'(^[0-9]{10}$)';
                                  RegExp regExp = RegExp(patttern);
                                  if (value.length == 0) {
                                    return 'Please enter mobile number';
                                  }
                                  else if (!regExp.hasMatch(value)) {
                                    return 'Please enter valid mobile number';
                                  }
                                  return null;
                                },
                              
                          ),
                            )
                          ),
                        Container(
                          width: MediaQuery.of(context).size.width*0.5,
                          margin: EdgeInsets.only(top: 12),
                        child: RaisedButton(

                          elevation: 10,
                          hoverColor: Colors.black12,
                          color: Colors.black,
                          child: Text("Login",style: TextStyle(color:Colors.white,letterSpacing: 0.3)),
                          onPressed: (){
                            if(_formKey.currentState.validate()){
                              _verifyPhoneNumber();
                            }
                          },
                        ),
                  )
                        ],),
                      ),
                    ),
                    secondChild: Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.2,left: 16,right: 16),
                      child: Form(
                        key: _sobarNameFormKey,
                          child: Column(children: <Widget>[
                          SizedBox(
                            height: 12,
                          ),
                          Container(
                            child: Theme(
                              data: Theme.of(context)
                                            .copyWith(primaryColor: Colors.deepOrange,),
                                child: TextFormField(
                                  controller: _sobarNameController,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    letterSpacing: 3
                                    ),
                                onChanged: (value){
                                  phone=value;
                                },
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                prefixText: ' ',
                                prefixIcon: Icon(MyFlutterApp.user_1),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white30, width: 0.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 0.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red.withOpacity(0.3), width: 0.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red.withOpacity(0.6), width: 0.0),
                                ),
                                counterText: '',
                                labelText: 'Sobar Name',
                                labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    letterSpacing: 3
                                    ),
                                contentPadding: EdgeInsets.all(0),
                                helperStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.8)
                                )
                              ),
                              cursorColor: Colors.deepOrange,
                              keyboardType: TextInputType.phone,
                              maxLengthEnforced: false,
                              validator: (value){
                                  String patttern = r'(^[A-Za-z]\w*$)';
                                  RegExp regExp = RegExp(patttern);
                                  if (value.length < 3) {
                                  return 'Name must be more than 2 charater';
                                }
                                else if (!regExp.hasMatch(value)) {
                                  return 'Name must begin with an alphabet';
                                }
                                else if (value.length > 15) {
                                  return 'Name must not be more than 15 characters';
                                }
                                  return null;
                                },
                              
                          ),
                            )
                          ),
                        Container(
                          width: MediaQuery.of(context).size.width*0.5,
                          margin: EdgeInsets.only(top: 12),
                        child: RaisedButton(
                          elevation: 10,
                          hoverColor: Colors.black12,
                          color: Colors.black,
                          child: Text("Submit",style: TextStyle(color:Colors.white,letterSpacing: 0.3)),
                          onPressed: () async {
                            if(_sobarNameFormKey.currentState.validate()){
                              sobarUser.sobarName=_sobarNameController.text;
                              await setUser();
                              Navigator.pop(context);
                            }
                          },
                        ),
                  )
                        ],),
                      ),
                    ),
                   )
                  ),
            ),
          )), onWillPop: () async{
            bool shouldPop=true;
            if(sobarName==''&&isLogged){
              await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: Text('Are you Sure?'),
                    content: Text('You are one step away to be a Sobar User'),
                    actions: <Widget>[
                      FlatButton(child: Text('Cancel'), onPressed: () {
                        Navigator.pop(context);
                        shouldPop= false;
                      },),
                      FlatButton(child: Text('Logout'), onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                        shouldPop= true;
                      },)
                    ],
                  );
                }, 
              );
              
            }
            // if(shouldPop){
            //   bannerAd?.dispose();
            // }
            return Future.value(shouldPop);
          },
        ),
      ],
    );
  }

  void _verifyPhoneNumber() async {
    setState(() {
       isVerified=true; 
      });
    // setState(() {
    //   _message = '';
    // });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential);
      // setState(() {
      //   _message = 'Received phone auth credential: $phoneAuthCredential';
        
      // });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
        _message =
            'Phone number verification failed';
        
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: '+91'+_phoneNumberController.text,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  // Example code of how to sign in with phone.
  void _signInWithPhoneNumber() async {
    setState(() {
      isLoading=true;
    });
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _smsController.text,
    );
    try{
      firebaseUser =
        (await _auth.signInWithCredential(credential)).user;
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(firebaseUser.uid == currentUser.uid);
      if (firebaseUser != null) {
        sobarUser=await FirebaseServices().getSobarUser(firebaseUser.uid);
        setState(() {
          isLogged=true;
        });
        if(sobarUser!=null){
          isPreviouslyLogged=true;
          _sobarNameController.text=sobarUser.sobarName;
        }else{
          isPreviouslyLogged=false;
          sobarUser=SobarUsers(firebaseUser.uid);
          sobarUser.phoneNumber=firebaseUser.phoneNumber;
        }
        // setUser(user.uid);
        // _message = 'Successfully signed in, uid: ' + user.uid;
        // Navigator.pop(context,user.uid);
      } else {
        
        _message = 'Sign in failed';
      }

    }catch (e){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text('Somethings not right. Please try again'),
            title: Text('Failed'),
            actions: <Widget>[FlatButton(child: Text('Ok'),onPressed: (){
              Navigator.of(context).pop();
              })],
          );
        }
      );
    }
    setState(() {
      isLoading=false;
    });
  }
  Future<void> setUser() async {
    // sobarUser=SobarUsers(firebaseUser.uid);
    // setUser.sobarName=sobarName==''?'sobar_user_':sobarName;
    // setUser.phoneNumber=_phoneNumberController.text;
      await FirebaseServices().setSobarUser(sobarUser);
      if(isPreviouslyLogged){
        await FirebaseServices().getSobarUser(sobarUser.userId).then((value){
          sobarUser=value;
      });
      }
      UserCache().setUser(sobarUser);
    }
}