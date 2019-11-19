class ReviewData{
  final String uid;
  String review;
  int rating;
  List<dynamic> photos;
  List<String> photoRefs;
  DateTime reviewTime;
  String type;
  int placeId;
  String authorName;
  String profilePhotoUrl;
  String relativeTime;

  ReviewData(this.uid){
    this.reviewTime=DateTime.now();
  }

  List<Map<String, dynamic>> toMapList() {
    return [{
      'author_id' : uid,
      'profile_photo_url':profilePhotoUrl,
      'author_name': authorName,
      'rating': rating,
      'photo_refs': photoRefs,
      'time': reviewTime,
      'text': review,
    }];
  }
}