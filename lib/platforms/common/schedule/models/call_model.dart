import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_eb/platforms/common/schedule/models/call_agora_callback.dart';

class CallModel{
  String id,channel,token,
      createdAt,
      scheduleId,
      receiverName,
      userName,userId,callMediaType,callType,groupId;
  List<String> receiverId;
  double acceptedPrice,vendorPrice,finalRate;
  int userUid,receiverUid,duration;
  List<CallAgoraCallBack>? agoraCallback;

  CallModel({this.id="",this.agoraCallback,this.groupId="",
    this.acceptedPrice=0.0,this.receiverUid=0,
    this.vendorPrice=0.0,this.finalRate=0.0,this.userUid=0,this.duration=0,
      this.channel="",this.token="", this.createdAt="", this.scheduleId="",
    this.receiverName="",this.userName="",this.receiverId=const <String>[],
    this.userId="",this.callMediaType="Video",this.callType="Single"});

  factory CallModel.fromMap(Map<String,dynamic> json,String id){
    List<String> receiverIds=[];
    List<CallAgoraCallBack> callbacks=[];
    if(json['receiverId'] is String){
      receiverIds.add(json['receiverId']);
    }
    else{
      List<String> receiverIdsFromDB=List.from(json['receiverId']);
      receiverIdsFromDB.map((e) => receiverIds.add(e));
    }
    if(json['callCharges']!=null && json['callCharges'] is List){
      callbacks=List.from(json['callCharges']).map((e) => CallAgoraCallBack.fromMap(Map.from(e))).toList();

    }

    return new CallModel(
      id: id,
      userId: json['userId'] as String,
      token: json['token'] as String,
        createdAt: json['createdAt']=="" ? DateTime.now().toIso8601String():(json['createdAt'] as Timestamp).toDate().toIso8601String(),
      receiverId: receiverIds,
      channel: json['channel'] as String,
        scheduleId: json['scheduleId'] as String,
      acceptedPrice: json['acceptedPrice'] as double,
      userUid: json['uId'] as int,
      vendorPrice: json['vendorPrice'] as double,
      userName: json['userName'] as String,
      receiverName: json['receiverName'] as String,
      duration: json['duration'] as int,
      agoraCallback: callbacks,
      callMediaType: json['callMediaType']==null ? "Video":json['callMediaType'],
      callType: json['callType']==null? "Single":json['callType'],
      groupId: json['groupId']==null ?"":json['groupId']
    );
  }
  toJson(){
    return {
      "userId":userId,
      "token":token,
      "receiverId":receiverId,
      'createdAt':createdAt==""?DateTime.now():DateTime.parse(createdAt),
      "channel":channel,
      "scheduleId":scheduleId,
      "acceptedPrice":acceptedPrice,
      "uId":userUid,
      "vendorPrice":vendorPrice,
      "userName":userName,
      "receiverName":receiverName,
      "duration":duration,
      "callCharges":agoraCallback==null || agoraCallback!.isEmpty ?[]:agoraCallback!.map((e) => e.toJson()).toList(),
      "callMediaType":callMediaType,
      "callType":callType,
      "groupId":groupId
    };
  }
}