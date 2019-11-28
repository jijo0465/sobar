import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudians/users.dart';
import 'package:rxdart/rxdart.dart';

class GoogleAuth{
  final GoogleSignIn _googleSignIn=GoogleSignIn();
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final Firestore _db=Firestore.instance;
  Observable<FirebaseUser> user;
  Observable<Map<String,dynamic>> profile;
  PublishSubject loading=PublishSubject();

  GoogleAuth(){
    user=Observable(_auth.onAuthStateChanged);
    profile=user.switchMap((FirebaseUser u){
      if(u!=null){
        return _db.collection('sobar_users').document(u.uid).snapshots().map((snap)=>snap.data);
      }else{
        return Observable.just({});
      }
    });
  }

  Future<FirebaseUser> googleSignIn() async{
    loading.add(true);
    GoogleSignInAccount googleUser=await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth=await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    FirebaseUser user;
    try{
      user=(await _auth.signInWithCredential(credential)).user;
    }catch(e){
      return null;
    }
    
    // if(user!=null){
      // SobarUsers sobarUser=SobarUsers(user.uid);
      // sobarUser.photoUrl=user.photoUrl;
      // sobarUser.sobarName=user.displayName;
      // sobarUser.email=user.email;
      // sobarUser.signInMethod='google';
      // updateUserData(user);
    // }
    loading.add(false);
    return user;

  }
  // void updateUserData(FirebaseUser user)async{
  //   DocumentReference ref=_db.collection('sobar_users').document(user.uid);
  //   return ref.setData({
  //     'user_id':user.uid,
  //     'sobar_name':user.displayName,
  //     'photo_url':user.photoUrl,
  //     'email':user.email,
  //   },merge: true);
  // }
  void signOut(){
    _auth.signOut();
  }

}

final GoogleAuth googleAuth=GoogleAuth();