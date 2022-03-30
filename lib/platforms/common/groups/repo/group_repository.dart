import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_eb/platforms/common/groups/model/chat/group_chat_model.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_freelancer_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_group_update_request.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_updated_request.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';

class GroupRepository {
  final userCollectionInstance = FirebaseFirestore.instance.collection('users');
  final groupsCollectionInstance = FirebaseFirestore.instance.collection('groups');

  Dio dio;

  GroupRepository(this.dio);

  final String meetingApiUrl =
      "https://46mbjojgi3.execute-api.ap-south-1.amazonaws.com/prod/schedule/meeting";
  final String updateMeetingApiUrl =
      "https://46mbjojgi3.execute-api.ap-south-1.amazonaws.com/prod/schedule/group-meeting";

  Future<String> createGroup(GroupModel model) async {
    DocumentReference reference=await this
        .userCollectionInstance
        .doc(model.adminId)
        .collection("groups")
        .add({"isOwner": true});
      model.groupId = reference.id;
      this
          .groupsCollectionInstance
          .doc(model.groupId)
          .set(model.toJson());
    return model.groupId;
  }

  void deleteGroup(String groupId) async {
    this.groupsCollectionInstance.doc(groupId).delete();
  }

  void addFreelancerToGroup(GroupFreelancerModel groupFreelancerModel,
      String groupId) async {
    this
        .groupsCollectionInstance
        .doc(groupId)
        .collection("freelancers")
        .doc(groupFreelancerModel.freelancerId)
        .set(groupFreelancerModel.toJson())
        .then((value) {
      this
          .userCollectionInstance
          .doc(groupFreelancerModel.freelancerId)
          .collection("groups")
          .doc(groupId)
          .set({"groupId": groupId, "isOwner": false});
    });
  }

  updateFreelancersStatus(String groupId, String freelancerId, String status) {
    SetOptions options=new SetOptions(
      merge: true
    );
    this
        .groupsCollectionInstance
        .doc(groupId)
        .collection("freelancers")
        .doc(freelancerId)
        .set({
      "requestStatus": status,
      "isAccept": status == "accepted" ? true : false
    }, options);
  }

  Future<List<DocumentSnapshot>> fetchAllGroups(
      String userId, String searchQuery, bool fetchMyOwnGroups) async {
    List<DocumentSnapshot> groupInfoList = [];
    QuerySnapshot snapshot = await this
        .userCollectionInstance
        .doc(userId)
        .collection("groups")
        .where("isOwner", isEqualTo: fetchMyOwnGroups ? true : false)
        .get();

    String groupId = "";
    for (DocumentSnapshot documentSnapshot in snapshot.docs) {
      groupId = documentSnapshot.id;
      DocumentSnapshot groupInfo =
          await this.groupsCollectionInstance.doc(groupId).get();
      if (searchQuery.trim() != "") {
        if ((groupInfo.data() as Map<String,dynamic>)["groupName"] == searchQuery) {
          groupInfoList.add(groupInfo);
        }
      } else {
        groupInfoList.add(groupInfo);
      }
    }
    return groupInfoList;
  }

  Future<QuerySnapshot> getScheduledCallsInAGroup(String groupId) async {
    return await this
        .groupsCollectionInstance
        .doc(groupId)
        .collection("schedules")
        .get();
  }

  Future<bool> createGroupSchedule(
      ScheduleNewRequestModel scheduleNewRequestModel) async {
    if (scheduleNewRequestModel.schedule.description == "")
      scheduleNewRequestModel.schedule.description = "Hi";
    Map<String, dynamic> scheduleRequestJson = scheduleNewRequestModel.toJson();
    Response response;
    try {
      response = await dio.post(meetingApiUrl, data: scheduleRequestJson);
      if (response.statusCode == 200){
        //TODO - Please verify
        await this.userCollectionInstance.doc(scheduleNewRequestModel.schedule.userId)
            .collection("schedules")
            .doc(response.data["docId"])
            .set(scheduleNewRequestModel.schedule.toJson());
        List<String> freelancers=scheduleNewRequestModel
            .schedule
            .freelancers.map((e) => e.id).toList();
        for(String s in freelancers) {
          await this.userCollectionInstance.doc(
              s)
              .collection("schedules")
              .doc(response.data["docId"])
              .set(scheduleNewRequestModel.schedule.toJson());
        }
        return true;
      }
      return false;
    } on DioError catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<Map<UserDTOModel, GroupFreelancerModel>> fetchAllFreelancersInGroup(
      String groupId) async {
    Map<UserDTOModel, GroupFreelancerModel> freelancersMap = {};
    List<DocumentSnapshot> freelancersList = [];
    QuerySnapshot snapshot = await this
        .groupsCollectionInstance
        .doc(groupId)
        .collection("freelancers")
        .get();
    for (DocumentSnapshot documentSnapshot in snapshot.docs) {
      DocumentSnapshot groupInfo = await this
          .userCollectionInstance
          .doc(documentSnapshot.id)
          .get();
      if (groupInfo.data() as Map<String,dynamic> != null) {
        UserDTOModel model =
            UserDTOModel.fromJson(groupInfo.data() as Map<String,dynamic>, groupInfo.id);
        freelancersMap[model] = GroupFreelancerModel.fromJson(
            documentSnapshot.data() as Map<String,dynamic>, documentSnapshot.id);
      }
    }
    return freelancersMap;
  }

  Future<DocumentSnapshot> getGroupInfoById(String groupId) {
    return this.groupsCollectionInstance.doc(groupId).get();
  }

  Future<DocumentSnapshot> getScheduledCallById(
      String groupId, String scheduleId) {
    return this
        .groupsCollectionInstance
        .doc(groupId)
        .collection("schedules")
        .doc(scheduleId)
        .get();
  }

  Future<void> updateScheduleCallDetails(
      String groupId, ScheduleNewRequestModel scheduleNewRequestModel)async {
    this
        .groupsCollectionInstance
        .doc(groupId)
        .collection("schedules")
        .doc(scheduleNewRequestModel.schedule.scheduleId)
        .update(scheduleNewRequestModel.toJson());
  }

  Future<bool> updateGroupSchedule(
      ScheduleUpdateGroupRequest scheduleUpdateGroupRequest) async {
    Response response;
    try {
      response = await dio.patch(updateMeetingApiUrl,
          data: scheduleUpdateGroupRequest.toJson());
      if (response.statusCode == 200) return true;
    } on DioError catch (e) {
      print(e.message);
      return false;
    }

    return response.data;
  }

  Future<QuerySnapshot> getChatMessages(String groupId) {
    return this
        .groupsCollectionInstance
        .doc(groupId)
        .collection("chatroom")
        .get();
  }

  Future<void> addChatMessageInGroup(
      String groupId, GroupChatModel groupChatModel)async {
    this
        .groupsCollectionInstance
        .doc(groupId)
        .collection("chatroom")
        .add(groupChatModel.toJson());
  }

  Future<void> removeUserFromFreelancer(String groupId,String userId)async{
    await this.groupsCollectionInstance.doc(groupId)
        .collection("freelancers")
        .doc(userId).delete();
    await this.userCollectionInstance.doc(userId)
    .collection("groups")
    .doc(groupId)
    .delete();
  }
}
