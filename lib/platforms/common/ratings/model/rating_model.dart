import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel{
  String review,userId,channelId,createdAt;
  double rating;
  RatingModel({this.rating=0.0,
    this.review="",this.userId="",this.createdAt="",this.channelId=""});
  factory RatingModel.fromMap(Map<String,dynamic> json){
    return new RatingModel(
      userId: json['userId'],
      rating: json['rating'],
      review: json['review'],
      channelId: json['channelId'],
      createdAt: json['createdAt']=="" ? DateTime.now().toIso8601String():(json['createdAt'] as Timestamp).toDate().toIso8601String(),
    );
  }

  factory RatingModel.fromMapForUser(Map<String,dynamic> json){
    return new RatingModel(
      userId: json['userId'],
      rating: json['rating'],
      review: json['review'],
      createdAt: json['createdAt']=="" ? DateTime.now().toIso8601String():(json['createdAt'] as Timestamp).toDate().toIso8601String(),
    );
  }

  toJson(){
    return {
      "userId":userId,
      "channelId":channelId,
      "rating":rating,
      "review":review,
      'createdAt':DateTime.parse(createdAt),
    };
  }

  toJsonForUser(){
    return {
      "userId":userId,
      "rating":rating,
      "review":review,
      'createdAt':DateTime.parse(createdAt),
    };
  }
}