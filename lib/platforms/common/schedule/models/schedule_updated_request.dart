import 'package:flutter_eb/shared/constants/constants.dart';
class ScheduleNewRequestModel{
  String type,id;
  ScheduleNewRequest schedule;
  ScheduleNewRequestModel({this.id="",this.type="",required this.schedule});
  factory ScheduleNewRequestModel.fromMap(Map<String,dynamic> json,String documentId){
    return new ScheduleNewRequestModel(
      type: json['type'] as String,
      id:documentId,
      schedule: ScheduleNewRequest.fromMapForSingle(Map.from(json['schedule']))
    );
  }

  factory ScheduleNewRequestModel.fromMapForGroup(Map<String,dynamic> json,String documentId){
    return new ScheduleNewRequestModel(
        type: json['type'] as String,
        id:documentId,
        schedule: ScheduleNewRequest.fromMap(Map.from(json['schedule']))
    );
  }

  toJson(){
    return {
      "type":type,
      "schedule":schedule.toJson()
    };
  }

  toJsonForSingle(){
    return {
      "type":type,
      "schedule":schedule.toJsonForSingle()
    };
  }
}
class ScheduleNewRequest{
  String groupId,freelancerId,
      scheduleId,
      callScheduled,
      description,status,userId,freelancerName,userName;
  int duration;
  double askedRate;
  List<Freelancers> freelancers;
  ScheduleNewRequest({
    this.groupId="",this.askedRate=0,
    this.scheduleId="",this.freelancers=const <Freelancers>[],
    this.freelancerId="",this.callScheduled="",this.description="",this.userId="",
    this.duration=0,this.status="",this.freelancerName="Unnamed",this.userName="Unnamed"
});
  factory ScheduleNewRequest.fromMap(Map<String,dynamic> json){
    return new ScheduleNewRequest(
        freelancers:(json['freelancers'] as List)
        .map((e) =>Freelancers.fromMap(Map.from(e)))
        .toList(),

      groupId: json['groupId'] as String,
      askedRate: json['askedRate'] as double,
      userId: json['userId'] as String,
      status: json['status'] as String,
      duration: json['duration'] as int,
      description: json['description'] as String,
      callScheduled: json['callScheduled'] as String,
      userName: json['userName'] as String,
      freelancerName: json['freelancerName'] as String
    );
  }

  factory ScheduleNewRequest.fromMapWithId(Map<String,dynamic> json,String id){
    return new ScheduleNewRequest(
        freelancers:(json['freelancers'] as List)
            .map((e) =>Freelancers.fromMap(Map.from(e)))
            .toList(),
    groupId: json['groupId'] as String,
    scheduleId: id,
    askedRate: json['askedRate'] as double,
    userId: json['userId'] as String,
    status: json['status'] as String,
    duration: json['duration'] as int,
    description: json['description'] as String,
    callScheduled: json['callScheduled'] as String,
    userName: json['userName'] as String,
    freelancerName: json['freelancerName'] as String
    );
  }

  factory ScheduleNewRequest.fromMapForSingle(Map<String,dynamic> json){
    return new ScheduleNewRequest(
        freelancerId: json['freelancerId'] as String,
        askedRate: json['askedRate'] as double,
        userId: json['userId'] as String,
        status: json['status'] as String,
        duration: json['duration'] as int,
        description: json['description'] as String,
        callScheduled: json['callScheduled'] as String,
        userName: json['userName'] as String,
        freelancerName: json['freelancerName'] as String
    );
  }

  toJson(){
    return{
      "groupId":groupId,
      //"freelancers":freelancers.map((e) => e.toJson()).toList(),
      "userId":userId,
      "status":status,
      'askedRate':askedRate,
      "duration":duration,
      "description":description,
      "callScheduled":callScheduled,
      "userName":userName,
      "freelancerName":freelancerName
    };
  }

  toJsonForSingle(){
    return{
      "userId":userId,
      "freelancerId":freelancerId,
      "status":status,
      'askedRate':askedRate,
      "duration":duration,
      "description":description,
      "callScheduled":callScheduled,
      "userName":userName,
      "freelancerName":freelancerName
    };
  }
}

class Freelancers{
  String id,status;
  Freelancers({required this.id,required this.status});
  factory Freelancers.fromMap(Map<String,dynamic> json){
    return new Freelancers(status: json['status'],id: json['id']);
  }
  toJson(){
    return{
      "id":id,
      "status":status
    };
  }
}