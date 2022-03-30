import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel{
  String message,refId,additionalId,userId,forKeyword,senderId,senderName,senderPic,type,createdAt;
  bool isRead;
  NotificationModel({this.createdAt="",
    this.message="",
    this.refId="",
    this.forKeyword="",
    this.additionalId="",
    this.userId="",
    this.senderId="",
    this.senderName="",this.senderPic="",this.type="",
  this.isRead=false});
  factory NotificationModel.fromMap(Map<String,dynamic> json){
    var notification=Map.from(json['notification']);
    var data=Map.from(json['data']);
    return new NotificationModel(
      createdAt: json['createdAt']=="" ? DateTime.now().toIso8601String() :
      (json['createdAt'] as Timestamp).toDate().toIso8601String(),
      message: notification['body'],
      userId: data['userId'],
      type: data['type'],
        additionalId: data['additionalId'],
        forKeyword:data['for'],
      senderId: data['userId'],
      refId: data['refId']==null ? "":data['refId'],
      isRead: json['isRead'],
      senderName: json['userName']==null ?"":json['userName'],
      senderPic: json['userPic']==null ?"":json['userPic']
    );
  }
}