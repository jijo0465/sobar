import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kudians/profile_page.dart';
import 'package:kudians/sobar_form_field.dart';
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

  @override
  Widget build(BuildContext context) {
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
                    highlightColor: Colors.blue,
                    defaultBorderColor: Colors.black,
                    hasTextBorderColor: Colors.deepOrange,
                    maxLength: 6,
                    onDone: (text){
                      print("DONE $text");
                    },
                    pinCodeTextFieldLayoutType: PinCodeTextFieldLayoutType.AUTO_ADJUST_WIDTH,
                    pinBoxDecoration: ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                    pinTextStyle: TextStyle(fontSize: 25.0,color: Colors.grey),
                    pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.scalingTransition,
                    pinTextAnimatedSwitcherDuration: Duration(milliseconds: 150),
                    pinBoxWidth: 50,
                    pinBoxHeight: 40,
                    wrapAlignment: WrapAlignment.end,
                    
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text("Verify"), onPressed: () {
                          _signInWithPhoneNumber();
                        },
                      ),
                      FlatButton(
                        child: Text("Cancel"),
                        onPressed: (){
                          setState(() {
                           isVerified=false; 
                          });
                        },
                      )
                    ],
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
                          // color: Colors.blue,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            
                          style: TextStyle(
                            color: Colors.orange[700],
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
                              color: Colors.orange[200]
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
                  margin: EdgeInsets.only(top: 8),
                child: RaisedButton(
                  elevation: 6,
                  hoverElevation: 10,
                  hoverColor: Colors.black12,
                  color: Colors.black54,
                  child: Text("Login",style: TextStyle(color:Colors.white,)),
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
          print('Verification Completed');
      _auth.signInWithCredential(phoneAuthCredential);
      // setState(() {
      //   _message = 'Received phone auth credential: $phoneAuthCredential';
        
      // });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
          print(authException.message);
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