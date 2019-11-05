import 'package:kudians/users.dart';

class UserCache {
  SobarUsers _user;
  static final UserCache _singleton = UserCache._internal();
  factory UserCache() {
    return _singleton;
  }

  UserCache._internal() {
    _user=null;
  }

  void setUser(SobarUsers user){
    this._user=user;
  }
  SobarUsers getUser(){
    return this._user;
  }
  bool isCached(){
    return this._user!=null;
  }
  void setPhotoUrl(String url){
    this._user.photoUrl=url;
  }
  void clearUserCache(){
    this._user=null;
  }
}