import 'package:timeago/timeago.dart' as timeago;
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

    Map<String, dynamic> toMap() {
    return {
      'author_id' : uid,
      'profile_photo_url':profilePhotoUrl,
      'author_name': authorName,
      'rating': rating,
      'photo_refs': photoRefs,
      'time': reviewTime,
      'text': review,
      'relative_time_description':timeago.format(DateTime.now().subtract(DateTime.now().difference(reviewTime)))
    };
  }
}