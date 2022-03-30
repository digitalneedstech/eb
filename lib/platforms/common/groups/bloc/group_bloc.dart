
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/bids/repo/bid_repository.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_state.dart';
import 'package:flutter_eb/platforms/common/groups/repo/group_repository.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_freelancer_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_updated_request.dart';
import 'package:flutter_eb/shared/services/notification/model/notification_message.dart';
import 'package:flutter_eb/shared/services/notification/repository/notification_repository.dart';
class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository groupRepository;
  final BidRepository bidRepository;
  final NotificationRepository notificationRepository;
  GroupBloc(this.groupRepository,this.bidRepository,this.notificationRepository) : super(GroupLoadedState());
  late Map<String,Set<UserDTOModel>> _freelanceIds;


  Map<String, Set<UserDTOModel>> get freelanceIds => _freelanceIds;

  set freelanceIds(Map<String, Set<UserDTOModel>> value) {
    _freelanceIds = value;
  }

  @override
  Stream<GroupState> mapEventToState(
      GroupEvent event,
      ) async* {
    if(event is AddFreelancerToGroupEvent){
      Set<UserDTOModel> freelancers=freelanceIds[event.groupId]!;
      freelancers.add(event.freelancerId);
      freelanceIds[event.groupId]=freelancers;
      yield AddFreelancerToGroupState(groupId: event.groupId);
    }
    if(event is RemoveFreelancerFromGroupEvent){
      Set<UserDTOModel> freelancers=freelanceIds[event.groupId]!;
      freelancers.remove(event.freelancerId);
      freelanceIds[event.groupId]=freelancers;
      yield RemoveFreelancerToGroupState(groupId: event.groupId);
    }
    if(event is CreateGroupEvent){
      yield LoadingGroupState();
      createGroup(event.groupModel,event.groupFreelancerModel);
      yield CreateGroupState(isGroupCreated: true);
    }
    if(event is CreateGroupWithoutFreelancerEvent){
      yield LoadingGroupState();
      await this.groupRepository.createGroup(event.groupModel);
      yield CreateGroupState(isGroupCreated: true);
    }
    if(event is AddMultipleUsersToGroupEvent){
      yield LoadingGroupState();
      for(int i=0;i<event.groupFreelancerModel.length;i++) {
        addUserToGroup(event.groupId, event.groupFreelancerModel[i]);
      }
      yield AddMultipleUsersToGroupState();
    }
    if(event is AddUserToGroupEvent){
      yield LoadingGroupState();
      try {
        addUserToGroup(event.groupId, event.groupFreelancerModel);
        yield AddUserToGroupState(isUserRequested: true);
      }
      catch(e){
        yield AddUserToGroupState(isUserRequested: false);
      }
    }

    if(event is FetchGroupsEvent){

      List<GroupModel> groupsList=[];
      yield LoadingGroupState();
      List<DocumentSnapshot> listOfGroups=await fetchAllGroups(event.userId,event.query,event.fetchMyOwnerGroups);
      for(DocumentSnapshot snapshot in listOfGroups){
        Map<UserDTOModel,GroupFreelancerModel> listOfFreelancers={};
        Map<UserDTOModel,GroupFreelancerModel> freelancers=await fetchAllUsersInAGroup(snapshot.id);
        GroupModel groupModel=GroupModel.fromJson(snapshot.data() as Map<String,dynamic>, snapshot.id);
        groupModel.groupMembers=freelancers;
        groupsList.add(groupModel);
      }
      yield FetchGroupsState(listOfGroupModels: groupsList);
    }

    if(event is FetchGroupByIdEvent){
      yield LoadingGroupState();
      GroupModel groupModel=await getGroupInfoById(event.groupId,event.userId);
      yield FetchGroupByIdState(groupModel: groupModel);
    }


  }

  void createGroup(GroupModel groupModel,GroupFreelancerModel groupFreelancerModel)async{
    String groupId=await this.groupRepository.createGroup(groupModel);
    addUserToGroup(groupId, groupFreelancerModel);
  }

  void addUserToGroup(String groupId, GroupFreelancerModel groupFreelancerModel,
      )async{
    this.groupRepository.addFreelancerToGroup(groupFreelancerModel, groupId);
    DocumentSnapshot groupSnapshot=await groupRepository.getGroupInfoById(groupId);
      GroupModel groupModel=GroupModel.fromJson(groupSnapshot.data() as Map<String,dynamic>, groupSnapshot.id);
    NotificationMessageNotificationModel notificationMessage=NotificationMessageNotificationModel(
        "notification",
        NotificationMessageNotificationPayloadModel(notification: NotificationMessageNotificationPayload(
            "Group Notification",
            "You have received an invitation to join ${groupModel.groupName} Group by ${groupModel.adminName}"
        ),data: new NotificationMessageDataPayload(
            groupId,
            groupFreelancerModel.freelancerId,
            "group","freelancer",""
        )),

    );
    notificationRepository.sendNotification(notificationMessage);
    NotificationMessage notificationMessageForMail = new NotificationMessage(
        type: "mail",
        payload: NotificationMessageEmailPayload(
            groupFreelancerModel.freelancerEmail,
            "Group Invitation",
            "You have received an invitation to join ${groupModel.groupName} Group by ${groupModel.adminName}"
        )
    );
    notificationRepository.sendNotification(notificationMessageForMail);
  }

  Future<List<DocumentSnapshot>> fetchAllGroups(String userId,String searchQuery,bool fetchMyOwnGroups)async{
    return this.groupRepository.fetchAllGroups(userId,searchQuery,fetchMyOwnGroups);
  }

  Future<Map<UserDTOModel,GroupFreelancerModel>> fetchAllUsersInAGroup(String groupId){
   return this.groupRepository.fetchAllFreelancersInGroup(groupId);
  }

  Future<GroupModel> getGroupInfoById(String groupId,String groupOnwerId)async{
    DocumentSnapshot snapshot=await this.groupRepository.getGroupInfoById(groupId);
    Map<UserDTOModel,GroupFreelancerModel> listOfFreelancers={};
    Map<UserDTOModel,GroupFreelancerModel> freelancersMap=await fetchAllUsersInAGroup(snapshot.id);

    for(UserDTOModel val in freelancersMap.keys.toList()){
      UserDTOModel existingUserModel=val;
      Map<bool,QueryDocumentSnapshot?> snapshot=await bidRepository.getBidsBetweenTwoUsers(groupOnwerId, val.userId);
      if(snapshot[true]!=null){
        BidModel bidModel=BidModel.fromJson(snapshot[true]!.data() as Map<String,dynamic>,
            snapshot[true]!.id);
        val.rateDetails.hourlyRate=bidModel.askedRate;
      }
      listOfFreelancers[val]=freelancersMap[existingUserModel]!;
    }
    GroupModel groupModel=GroupModel.fromJson(snapshot.data() as Map<String,dynamic>, snapshot.id);
    groupModel.groupMembers=listOfFreelancers;
    return groupModel;
  }
  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }
}
