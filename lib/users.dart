class SobarUsers{
  String userId;
  String sobarName;
  String phoneNumber;
  String location;
  String photoUrl;
  String email;
  String signInMethod;
  
  SobarUsers(String uid){
    this.userId=uid;
    this.sobarName='';
    this.phoneNumber='';
    this.photoUrl='';
    this.email='';
    this.signInMethod='';
  }

  Map<String, String> toMap() {
    return {
      'user_id':this.userId,
      'sobar_name':this.sobarName,
      'phone_number':this.phoneNumber,
      'photo_url':this.photoUrl,
      'email':this.email,
      'sign_in_method':this.signInMethod
    };
  }
}