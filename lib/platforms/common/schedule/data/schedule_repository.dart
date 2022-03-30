import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_eb/app/my_app.dart';
import 'package:flutter_eb/platforms/common/schedule/models/call_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_message.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_update_request_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_updated_request.dart';

class ScheduleRepository {
  final collectionInstance = FirebaseFirestore.instance.collection('users');
  final groupsCollectionInstance = FirebaseFirestore.instance.collection('groups');
  Dio dio;

  ScheduleRepository(this.dio);

  final String meetingApiUrl = "https://46mbjojgi3.execute-api.ap-south-1.amazonaws.com/prod/schedule/meeting";
  final String agoraAPIUrl = "https://46mbjojgi3.execute-api.ap-south-1.amazonaws.com/prod/schedule/agora-api";

  Future<bool> createSchedule(ScheduleRequest scheduleRequest) async {
    if (scheduleRequest.description == "")
      scheduleRequest.description = "Hi";
    if(scheduleRequest.userName=="")
      scheduleRequest.userName="test";
    if(scheduleRequest.freelancerName=="")
      scheduleRequest.freelancerName="test";
    Response response;
    /*ScheduleNewRequestModel scheduleNewRequestModel=new ScheduleNewRequestModel(
      schedule: new ScheduleNewRequest(
        userId:
      )
    );*/
    ScheduleNewRequestModel scheduleNewRequestModel =new ScheduleNewRequestModel(
      type: "single",
      schedule: new ScheduleNewRequest(
        userId: scheduleRequest.userId,
        description: scheduleRequest.description,
        userName: scheduleRequest.userName,
        freelancerName: scheduleRequest.freelancerName,
          freelancerId: scheduleRequest.freelancerId,
        status: "pending",
        duration: scheduleRequest.duration,
        askedRate: scheduleRequest.askedRate,
        callScheduled: scheduleRequest.callScheduled

      )
    );
    Map<String,dynamic> scheduledJson=scheduleNewRequestModel.toJsonForSingle();
    try {
      response = await dio.post(meetingApiUrl,
          data: scheduledJson);
      if (response.statusCode == 200)
        return true;
    } on DioError catch (e) {
      print(e.message);
      return false;
    }

    return response.data;
  }

  Future<bool> createGroupSchedule(ScheduleNewRequestModel scheduleNewRequestModel) async {
    if (scheduleNewRequestModel.schedule.description == "")
      scheduleNewRequestModel.schedule.description= "Hi";
    Map<String, dynamic> scheduleRequestJson = scheduleNewRequestModel.toJson();
    Response response;
    try {
      response = await dio.post(meetingApiUrl,
          data: scheduleRequestJson);
      if (response.statusCode == 200) {
        ScheduleRequest scheduleRequest=new ScheduleRequest(
          id: response.data["id"],
          createdAt: DateTime.now().toIso8601String(),
          status: scheduleNewRequestModel.schedule.status,
            description: scheduleNewRequestModel.schedule.description,
            userId: scheduleNewRequestModel.schedule.userId,
          userName: scheduleNewRequestModel.schedule.userName,
          freelancerName: scheduleNewRequestModel.schedule.freelancerName,
          freelancerId: scheduleNewRequestModel.schedule.freelancerId,
          askedRate: scheduleNewRequestModel.schedule.askedRate,
          callScheduled: scheduleNewRequestModel.schedule.callScheduled,
          duration: scheduleNewRequestModel.schedule.duration
        );
        //TODO - Please verify
        await this.collectionInstance.doc(scheduleNewRequestModel.schedule.userId)
            .collection("schedules")
            .doc(response.data["docId"])
            .set(scheduleRequest.toJson());
        return true;
      }
    } on DioError catch (e) {
      print(e.message);
      return false;
    }

    return response.data;
  }

  Future<DocumentSnapshot> getGroupScheduledCallStatus(String groupId,String scheduleId){
    return this.groupsCollectionInstance.doc(groupId).collection("schedule").doc(scheduleId).get();
  }
  Future<bool> updateSchedule(
      ScheduleUpdateRequest scheduleUpdateRequest) async {
    Response response;
    try {
      response = await dio.patch(meetingApiUrl,
          data: scheduleUpdateRequest.toJson());
      if (response.statusCode == 200)
        return true;
    } on DioError catch (e) {
      print(e.message);
      return false;
    }

    return response.data;
  }

  Future<DocumentSnapshot> getScheduledCallInfo(String scheduleId,
      String userId) async {
    return this.collectionInstance.doc(userId)
        .collection("schedules")
        .doc(scheduleId)
        .get();
  }

  Future<DocumentSnapshot> getCallInfo(String channelId,
      String userId) async {
    return this.collectionInstance.doc(userId)
        .collection("calls")
        .doc(channelId)
        .get();
  }


  Future<QuerySnapshot> getChatMessages(String userId,
      String scheduleId) {
    return this.collectionInstance.doc(userId).collection("schedules")
        .doc(scheduleId).collection("chats")
        .orderBy("createdAt",descending: true)
        .get();
  }

  sendMessage(String userId,String chatUserId, ScheduleMessage chatMessageModel) {
    dynamic json;
    if(chatMessageModel.userId=="") {
      json = {
        "message": chatMessageModel.message,
        "createdAt":DateTime.now().toIso8601String(),
        "freelancerId": chatMessageModel.freelancerId
      };
    }
      else{
      json={
        "message":chatMessageModel.message,
        "createdAt":DateTime.now().toIso8601String(),
        "userId":chatMessageModel.userId
      };
    }

    this.collectionInstance.doc(userId).collection(
        "schedules").doc(chatMessageModel.id).collection("chats").add(
        json);
    this.collectionInstance.doc(chatUserId).collection(
        "schedules").doc(chatMessageModel.id).collection("chats").add(
        json);
  }

  Future<CallModel> getCallModelFromScheduleRequest(ScheduleRequest? scheduleRequest)async{
    Response response;
    CallModel callModel=new CallModel();
    if(scheduleRequest==null){
      try {
        response = await dio.post(agoraAPIUrl,
            data: {
              "channel": callModel.channel
            });
        if (response.statusCode == 200) {
          callModel.token = response.data["token"];
          callModel.userUid = int.parse(response.data["uid"].toString());
          callModel.id = callModel.channel;
        }
        await this.collectionInstance.doc(callModel.userId)
            .collection("calls")
            .doc(callModel.id)
            .set(callModel.toJson());
      } on DioError catch (e) {
        print(e.message);
        return CallModel(id: "", scheduleId: "");
      }
      return callModel;
    }
    else {
      return await _getTokenForAGroupOrSingleCallAsAFreelancer(scheduleRequest);
    }

  }

  Future<CallModel> getCallModelFromSchduleGroupRequest(String groupId,
      ScheduleNewRequestModel scheduleNewRequestModel)async{
    return await _getTokenForAGroupOrSingleCallAsAFreelancer(scheduleNewRequestModel.schedule);
  }


  Future<CallModel> _getTokenForAGroupOrSingleCallAsAFreelancer(dynamic scheduleRequest) async {
    String userId="";
    String channelId="";
    String freelancerId="";
    CallModel callModel;
    if(scheduleRequest is ScheduleRequest){
      userId=scheduleRequest.userId;
      channelId=scheduleRequest.id;
      freelancerId=scheduleRequest.freelancerId;
    }
    else if(scheduleRequest is ScheduleNewRequest){
      userId=scheduleRequest.userId;
      channelId=scheduleRequest.scheduleId;
      freelancerId=scheduleRequest.freelancerId;
    }
    DocumentSnapshot snapshot = await this.collectionInstance
        .doc(userId)
        .collection("calls").doc(channelId).get();
    if (!snapshot.exists)
      return CallModel();
    else {
      callModel= CallModel.fromMap(
          snapshot.data() as Map<String, dynamic>, snapshot.id);
      try {
        Response response = await dio.post(agoraAPIUrl,
            data: {
              "channel": callModel.channel
            });
        if (response.statusCode == 200) {
          callModel.token = response.data["token"];
          callModel.userUid = int.parse(response.data["uid"].toString());
        }
        await this.collectionInstance
            .doc(freelancerId)
            .collection("calls")
            .doc(callModel.id)
            .set(callModel.toJson());
      } on DioError catch (e) {
        print(e.message);
        return CallModel(id: "", scheduleId: "");
      }
    }

    return callModel;
  }

  Future<CallModel> getTokenAndUpdateCall(CallModel callModel) async {
    Response response;
    try {
      response = await dio.post(agoraAPIUrl,
          data: {
          "channel":callModel.channel
          });
      if (response.statusCode == 200){
        callModel.token=response.data["token"];
        callModel.userUid=int.parse(response.data["uid"].toString());
        callModel.id=callModel.channel;
        String callId=callModel.scheduleId==""?callModel.id:callModel.scheduleId;
        await this.collectionInstance.doc(callModel.userId)
            .collection("calls")
            .doc(callId)
            .set(callModel.toJson());
        return callModel;
      }

    } on DioError catch (e) {
      print(e.message);
      return CallModel(id: "",scheduleId: "");
    }

    return response.data;
  }

  Future<CallModel> getTokenAndUpdateCallForGroup(String groupId,CallModel callModel) async {
    Response response;
    try {
      response = await dio.post(agoraAPIUrl,
          data: {
            "channel":callModel.channel
          });
      if (response.statusCode == 200){
        callModel.token=response.data["token"];
        callModel.userUid=int.parse(response.data["uid"].toString());
        callModel.id=callModel.scheduleId==""?callModel.id:callModel.scheduleId;
        callModel.groupId=groupId;
        await this.collectionInstance.doc(callModel.userId)
        .collection("calls")
        .doc(callModel.id)
            .set(callModel.toJson());
        return callModel;
      }

    } on DioError catch (e) {
      print(e.message);
      return CallModel(id: "",scheduleId: "");
    }

    return response.data;
  }

  Future<List<int>> getUsersAlreadyInCall(String groupId,CallModel callModel)async{
    List<int> usersAlreadyInCall=[];
    QuerySnapshot freelancersSnapshot=await this.groupsCollectionInstance.doc(groupId).collection("calls")
        .doc(callModel.scheduleId)
        .collection("freelancers").get();
    QuerySnapshot usersSnapshot=await this.groupsCollectionInstance.doc(groupId).collection("calls")
        .doc(callModel.scheduleId)
        .collection("users").get();
    if(freelancersSnapshot.docs.isNotEmpty) {
      for (DocumentSnapshot documentSnapshot in freelancersSnapshot.docs) {
        if(documentSnapshot.data()!=null)
          if((documentSnapshot.data() as Map<String, dynamic>)["leftAt"]==null) {
            usersAlreadyInCall.add(
                (documentSnapshot.data() as Map<String, dynamic>)["uId"]);
          }
      }
    }
    if(usersSnapshot.docs.isNotEmpty) {
      for (DocumentSnapshot documentSnapshot in usersSnapshot.docs) {
        if(documentSnapshot.data()!=null) {
          if((documentSnapshot.data() as Map<String, dynamic>)["leftAt"]==null) {
            usersAlreadyInCall.add(
                (documentSnapshot.data() as Map<String, dynamic>)["uId"]);
          }
        }
      }
    }
    return usersAlreadyInCall;
  }
/*
  void addUserJoiningTime(bool isUser,bool isForGroup,String dateTime,CallModel callModel,
      String groupId,String userId,int uId){
    if(isUser) {
      if(isForGroup){
        this.groupsCollectionInstance.doc(groupId).collection("calls")
            .doc(callModel.scheduleId==""?callModel.channel:callModel.scheduleId)
            .collection("users")
            .doc(userId)
            .set({
          "id": userId,
          "uId":uId,
          "joinedAt": dateTime
        });
      }
      else {
        this.collectionInstance.doc(callModel.userId).collection("calls")
            .doc(callModel.scheduleId==""?callModel.channel:callModel.scheduleId).collection("users")
            .doc(userId)
            .set({
          "id": userId,
          "uId":uId,
          "joinedAt": dateTime
        });
        this.collectionInstance.doc(callModel.receiverId).collection("calls")
            .doc(callModel.scheduleId==""?callModel.channel:callModel.scheduleId).collection("users")
            .doc(userId)
            .set({
          "id": userId,
          "uId":uId,
          "joinedAt": dateTime
        });
      }
    }else {
      if(isForGroup){
        this.groupsCollectionInstance.doc(groupId).collection("calls")
            .doc(callModel.scheduleId==""?callModel.channel:callModel.scheduleId)
            .collection("freelancers")
            .doc(userId)
            .set({
          "id": userId,
          "uId":uId,
          "joinedAt": dateTime
        });
      }
      else {
        this.collectionInstance.doc(callModel.receiverId).collection(
            "calls")
            .doc(callModel.scheduleId==""?callModel.channel:callModel.scheduleId)
        .collection("freelancers")
        .doc(userId)
            .set({
          "id": userId,
          "uId":uId,
          "joinedAt": dateTime
        });
        this.collectionInstance.doc(callModel.userId).collection("calls")
            .doc(callModel.scheduleId==""?callModel.channel:callModel.scheduleId).collection("freelancers")
            .doc(userId)
            .set({
          "id": userId,
          "uId":uId,
          "joinedAt": dateTime
        });
      }
    }
  }*/

  void userloggingOffTime(bool isUser,bool isForGroup,String dateTime,CallModel callModel,
      String groupId,String userId,int uId){
    if(isUser) {
      this.collectionInstance.doc(callModel.userId)
          .collection("calls")
          .doc(callModel.scheduleId==""?callModel.channel:callModel.scheduleId)
          .set(callModel.toJson(),SetOptions(merge: true));
      this.collectionInstance.doc(callModel.userId)
      .set({
        "isTerminated":true
      },SetOptions(merge: true));
      for(String receiverId in callModel.receiverId){
        this.collectionInstance.doc(receiverId)
            .set({
          "isTerminated":true
        },SetOptions(merge: true));
      }
    }else {
      for(String receiverId in callModel.receiverId){
        this.collectionInstance.doc(receiverId)
            .collection("calls")
            .doc(callModel.scheduleId==""?callModel.channel:callModel.scheduleId)
            .set(callModel.toJson(),SetOptions(merge: true));
      }

    }
  }
}