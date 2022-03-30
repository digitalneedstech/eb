import 'package:cloud_firestore/cloud_firestore.dart';

class CallAgoraCallBack{
  String isCallType;
  int duration;
  DateTime startTime,endTime;
  CallAgoraCallBack(this.duration,this.startTime,this.endTime,this.isCallType);
  factory CallAgoraCallBack.fromMap(Map<String,dynamic>? json){
    if(json==null)
      return new CallAgoraCallBack(
          0,DateTime.now(),DateTime.now(),"Video"
      );
    return new CallAgoraCallBack(
        json['duration'],(json['startTime'] as Timestamp).toDate(),
        (json['endTime'] as Timestamp).toDate(),json['isCallType']
    );
  }
  toJson(){
    return {
      "duration":duration,
      "startTime":startTime,
      "endTime":endTime,
      "isCallType":isCallType
    };
  }
}