import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/bids/repo/bid_repository.dart';
import 'package:flutter_eb/platforms/common/groups/repo/group_repository.dart';
import 'package:flutter_eb/platforms/common/landing_page/bloc/landing_operations_bloc/landing_update_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/bloc/landing_operations_bloc/landing_update_state.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_freelancer_model.dart';
/*
TODO- Update user model with required new model values instead of null
 */
class LandingUpdateBloc extends Bloc<LandingUpdateEvent, LandingUpdateState> {
  final GroupRepository groupRepository;
  final BidRepository bidRepository;
  LandingUpdateBloc(this.groupRepository,this.bidRepository) : super(LandingUpdateLoadedState());
  Map<String,UserDTOModel> _freelancersToBeAdded={};


  Map<String, UserDTOModel> get freelancersToBeAdded => _freelancersToBeAdded;

  set freelancersToBeAdded(Map<String, UserDTOModel> value) {
    _freelancersToBeAdded = value;
  }
//TODO- Make Bloc For this repo and for Patient save
  @override
  Stream<LandingUpdateState> mapEventToState(
      LandingUpdateEvent event,
      ) async* {
    if(event is AddUsersToGroupEvent){
      yield AddUsersToGroupInProgressState();
      List<GroupFreelancerModel> freelancers=[];
      for(UserDTOModel userDTOModel in freelancersToBeAdded.values){
        String finalRate;
        Map<bool,QueryDocumentSnapshot?> snapshot=await bidRepository
            .getBidsBetweenTwoUsers(event.ownerId, userDTOModel.userId);
        if(snapshot[true]!=null) {
          BidModel bidModel = BidModel.fromJson(
              snapshot[true]!.data() as Map<String, dynamic>,
              snapshot[true]!.id);
          finalRate=bidModel.askedRate.toString();
        }
        else{
          finalRate=userDTOModel.rateDetails.hourlyRate.toString();
        }
        groupRepository.addFreelancerToGroup(new GroupFreelancerModel(
            freelancerId:userDTOModel.userId,
            freelancerName:userDTOModel.personalDetails.displayName,
            createdAt: DateTime.now().toIso8601String(),
            isAccept: false,
            finalRate: finalRate,
            freelancerEmail: userDTOModel.personalDetails.email,
            profilePic: userDTOModel.personalDetails.profilePic
        ),  event.groupId);
      }
      yield AddUsersToGroupState(isAdded: true);

    }
    if(event is AddFreelancerToGroupEvent){
      yield AddOrRemoveFreelancerToGroupInProgressState();
      if(!freelancersToBeAdded.containsKey(event.userDTOModel.userId)){
        freelancersToBeAdded[event.userDTOModel.userId]=event.userDTOModel;
      }
      yield AddOrRemoveFreelancerToGroupState(userIds: freelancersToBeAdded.keys.toList());
    }

    if(event is RemoveFreelancerToGroupEvent){
      yield AddOrRemoveFreelancerToGroupInProgressState();
      if(freelancersToBeAdded.containsKey(event.userId)){
        freelancersToBeAdded.remove(event.userId);
      }
      yield AddOrRemoveFreelancerToGroupState(userIds: freelancersToBeAdded.keys.toList());
    }

  }


  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }
}
