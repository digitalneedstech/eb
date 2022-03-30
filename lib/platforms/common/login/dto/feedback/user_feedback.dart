import 'package:cloud_firestore/cloud_firestore.dart';

class UserFeedbackModel{
  String id,createdAt,review,userId;
  double rating;
  UserFeedbackModel({this.userId="",this.id="",this.createdAt="",this.review="",this.rating=0.0});
  factory UserFeedbackModel.fromMap(Map<String,dynamic> json){
    return new UserFeedbackModel(
      createdAt: (json['createdAt'] as Timestamp).toDate().toIso8601String(),
      userId: json['userId'],
      review: json['review'],
      rating: json['rating']
    );
  }

  toJson(){
    return{
      "createdAt":createdAt==""? DateTime.now():DateTime.parse(createdAt),
      "userId":userId,
      "review":review,
      "rating":rating
    };
  }
}