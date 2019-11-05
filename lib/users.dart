class SobarUsers{
  String userId;
  String firstName;
  String lastName;
  String sobarName;
  String phoneNumber;
  String location;
  String photoUrl;
  
  SobarUsers(String uid){
    this.userId=uid;
    this.firstName='';
    this.sobarName='';
    this.lastName='';
    this.phoneNumber='';
    this.photoUrl='';

  }

  Map<String, String> toMap() {
    return {
      'user_id':this.userId,
      'first_name':this.firstName,
      'last_name':this.lastName,
      'sobar_name':this.sobarName,
      'phone_number':this.phoneNumber,
      'photo_url':this.photoUrl
    };
  }
}