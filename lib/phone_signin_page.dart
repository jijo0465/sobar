import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
class PhoneSignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PhoneSignInSectionState();
}

class _PhoneSignInSectionState extends State<PhoneSignInPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
final FirebaseAuth _auth = FirebaseAuth.instance;
  String _message = '';
  String _verificationId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isVerified=false;
  BannerAd bannerAd;
    BannerAd buildBannerAd(){
      return BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: (MobileAdEvent event){
        }
      );
    }
@override
  void initState() {
    bannerAd = buildBannerAd()..load();
    super.initState();
  }

  @override
  void dispose() {
    bannerAd?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    bannerAd..load()..show();
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        iconTheme: IconThemeData(color: Colors.orange[900]),
        title: Text('Sobar Sign In',style: TextStyle(
          color: Colors.orange[900]
        ),),
        
      ),
    body:Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.1,0.3, 0.5, 0.7,0.8, 0.9], 
                colors: <Color>[
                  Colors.black,
                  Colors.grey[900],
                  Colors.grey[800],
                  Colors.grey[700],
                  Colors.grey[600],
                  Colors.grey[500],
                  ],
              )
            ),
      child: SingleChildScrollView(
        
        child: Center(
          heightFactor: 3.6,
          child: Container(
                margin: EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: isVerified?Container(
                  child: Column(
                    children: <Widget>[
                      
                    PinCodeTextField(
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
                ):Column(children: <Widget>[
                  
                  Padding(
                    padding: const EdgeInsets.only(left: 40,right: 40,),
                    child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child:Container(
                          child: TextFormField(
                            textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.deepOrange[400],
                            fontSize: 25,
                            letterSpacing: 5
                            ),
                          readOnly: true,
                          initialValue: '+91',
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            helperText: "  ",
                          ),
                      ),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Container( 
                          margin: EdgeInsets.only(left: 18),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              autofocus: true,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.orange[900],
                                fontSize: 25,
                                letterSpacing: 5
                                ),
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
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            helperText: "Login with your phone",
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
                          
                        ))
                        ),
                      )],
                ),
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
                ],) 
              ),
        )),
    ));
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
      // setState(() {
      //   _message =
      //       'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      // });
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
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _smsController.text,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
      if (user != null) {
        // ProfilePage.isLogged=true;
        _message = 'Successfully signed in, uid: ' + user.uid;
        Navigator.pop(context,user.uid);
      } else {
        _message = 'Sign in failed';
      }
  }
}