class ReviewData{
  String review;
  int rating;
  List<dynamic> photos;
  List<String> photoRefs;
  DateTime reviewTime;
  String type;
  int placeId;
  String authorName;

  ReviewData(){
    this.reviewTime=DateTime.now();
  }

  List<Map<String, dynamic>> toMapList() {
    return [{
      'author_name': authorName,
      'rating': rating,
      'photo_refs': photoRefs,
      'time': reviewTime,
      'text': review
    }];
  }
}