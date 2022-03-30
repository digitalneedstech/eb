import 'package:cloud_firestore/cloud_firestore.dart';

class WishListModel{
  String createdAt,freelancerId;
  WishListModel({this.createdAt="",this.freelancerId=""});
  WishListModel fromJson(
      Map<String, dynamic> json) {
    return WishListModel(
        createdAt: json['createdAt'] =="" ? DateTime.now().toIso8601String():(json['createdAt'] as Timestamp).toDate().toIso8601String(),
        freelancerId: json['freelancerId'] as String
    );
  }

  toJson() {
    return {
      'createdAt': DateTime.parse(createdAt),
      'freelancerId': freelancerId
    };
  }
}