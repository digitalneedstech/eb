import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_freelancer_model.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/call/call_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/call/call_event.dart';
import 'package:flutter_eb/platforms/common/schedule/models/call_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_updated_request.dart';
import 'package:flutter_eb/platforms/common/schedule/schedule.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/constants/routes.dart';

void walletCalculationBeforeStartingCallForSingleFreelancer(BuildContext context, int index,
    ScheduleRequest scheduleRequest) {
  double finalRate =calculateRate(scheduleRequest.duration,double.parse(scheduleRequest.askedRate.toString()));
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  String refId =
  List.generate(10, (index) => _chars[r.nextInt(_chars.length)]).join();
  CallModel callModel = CallModel(
      createdAt: DateTime.now().toIso8601String(),
      userId: scheduleRequest.userId,
      token: "",
      duration: scheduleRequest.duration,
      scheduleId: scheduleRequest.id,
      receiverId:[ scheduleRequest.freelancerId],
      channel: refId,
      receiverName: scheduleRequest.freelancerName,
      userName: scheduleRequest.userName);
  FirebaseFirestore.instance
      .collection("utils")
      .doc("parameters")
      .get()
      .then((value) {
    if (index == 0) {
      callModel.acceptedPrice = finalRate * value["proMemberDiscount"];
      callModel.vendorPrice=finalRate * value["vendorPayment"]* value["proMemberDiscount"];
    }
    else if (index == 1) {
      callModel.acceptedPrice =
          finalRate * value["enterpriseMemberDiscount"];
      callModel.vendorPrice=finalRate * value["vendorPayment"]* value["enterpriseMemberDiscount"];
    }
    else {
      callModel.acceptedPrice = finalRate;
      callModel.vendorPrice=finalRate * value["vendorPayment"];
    }
    if (callModel.acceptedPrice <
        BlocProvider.of<LoginBloc>(context).userDTOModel.walletAmount) {
      Navigator.popAndPushNamed(context, Routes.WALLET);
    } else {
      updateCallTerminatedAndStartedFlagsForUserAndFreelancers(context,scheduleRequest.userId,
          [scheduleRequest.freelancerId])
      .then((value){
        BlocProvider.of<CallBloc>(context).add(
              GetAgoraTokenAndMapAgoraVideoEvent(
                  groupId: "",
                  callModel: callModel));
              });
    }
  });
}


void walletCalculationBeforeStartingCallForUpdatedModelForAGroup(BuildContext context,
    int index,ScheduleNewRequestModel scheduleRequest,
    String groupId,{String userType="user"})async {
  double finalRate =calculateRate(scheduleRequest.schedule.duration,
      double.parse(scheduleRequest.schedule.askedRate.toString()));
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  String refId =
  List.generate(10, (index) => _chars[r.nextInt(_chars.length)]).join();
  Map<UserDTOModel,GroupFreelancerModel> freelancers=await BlocProvider.of<GroupBloc>(context).groupRepository.fetchAllFreelancersInGroup(groupId);
    List<String> users = freelancers.keys.map((e) => e.userId).toList();

  CallModel callModel = CallModel(
      createdAt: DateTime.now().toIso8601String(),
      userId: scheduleRequest.schedule.userId,
      token: "",
      callType: "Group",
      duration: scheduleRequest.schedule.duration,
      scheduleId: scheduleRequest.schedule.scheduleId,
      receiverId:users,
      channel: refId,
      receiverName: groupId=="" ?"Group":scheduleRequest.schedule.freelancerName,
      userName: scheduleRequest.schedule.userName);
  FirebaseFirestore.instance
      .collection("utils")
      .doc("parameters")
      .get()
      .then((value) {
    if (index == 0) {
      callModel.acceptedPrice = finalRate * value["proMemberDiscount"];
      callModel.vendorPrice=finalRate * value["vendorPayment"]* value["proMemberDiscount"];
    }
    else if (index == 1) {
      callModel.acceptedPrice =
          finalRate * value["enterpriseMemberDiscount"];
      callModel.vendorPrice=finalRate * value["vendorPayment"]* value["enterpriseMemberDiscount"];
    }
    else {
      callModel.acceptedPrice = finalRate;
      callModel.vendorPrice=finalRate * value["vendorPayment"];
    }
    if (callModel.acceptedPrice <
        BlocProvider.of<LoginBloc>(context).userDTOModel.walletAmount) {
      Navigator.popAndPushNamed(context, Routes.WALLET);
    } else {
      updateCallTerminatedAndStartedFlagsForUserAndFreelancers(context,callModel.
      userId,callModel.receiverId)
          .then((value){
        if(userType=="user") {
          BlocProvider.of<CallBloc>(context).add(
              GetAgoraTokenAndMapAgoraVideoEvent(
                  callModel: callModel, groupId: groupId));
        }
        else{
          BlocProvider.of<CallBloc>(context).add(
              GetAgoraCallModel(scheduleRequest: scheduleRequest,userId: "",groupId: ""));
        }
      });

    }
  });
}

void walletCalculationBeforeStartingCallForInstantCall(BuildContext context,int index,
    CallModel callModel) {
  double finalRate =calculateRate(callModel.duration,callModel.acceptedPrice);
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  String refId =
  List.generate(10, (index) => _chars[r.nextInt(_chars.length)]).join();
  callModel.channel=refId;
  FirebaseFirestore.instance
      .collection("utils")
      .doc("parameters")
      .get()
      .then((value) {
    if (index == 0) {
      callModel.acceptedPrice = finalRate * value["proMemberDiscount"];
      callModel.vendorPrice=finalRate * value["vendorPayment"]* value["proMemberDiscount"];
    }
    else if (index == 1) {
      callModel.acceptedPrice =
          finalRate * value["enterpriseMemberDiscount"];
      callModel.vendorPrice=finalRate * value["vendorPayment"]* value["enterpriseMemberDiscount"];
    }
    else {
      callModel.acceptedPrice = finalRate;
      callModel.vendorPrice=finalRate * value["vendorPayment"];
    }
    if (callModel.acceptedPrice <
        BlocProvider.of<LoginBloc>(context).userDTOModel.walletAmount) {
      Navigator.popAndPushNamed(context, Routes.WALLET);
    } else {
      updateCallTerminatedAndStartedFlagsForUserAndFreelancers(context,callModel.userId,
          callModel.receiverId)
          .then((value){
        BlocProvider.of<CallBloc>(context).add(
              GetAgoraTokenAndMapAgoraVideoEvent(groupId: "",
                  callModel: callModel));
      });
    }
  });
}

double calculateRate(int duration, double acceptedPrice){
  return double.parse((duration*(acceptedPrice/60)).toStringAsFixed(2));
}

Future<void> updateCallTerminatedAndStartedFlagsForUserAndFreelancers(BuildContext context,
    String userId,List<String> freelancerId)async{
  UserDTOModel userDTOModel=BlocProvider.of<LoginBloc>(context).userDTOModel;
  userDTOModel.isCallActive=true;
  userDTOModel.isTerminated=false;
  await BlocProvider.of<LoginBloc>(context).loginRepository.updateUser(userDTOModel);
    for (String receiverId in freelancerId) {
      DocumentSnapshot documentSnapshot = await BlocProvider
          .of<LoginBloc>(context)
          .loginRepository
          .getUserByUid(receiverId);
      UserDTOModel freelancerDTOModel = UserDTOModel.fromJson(
          documentSnapshot.data() as Map<String, dynamic>,
          documentSnapshot.id);
      freelancerDTOModel.isTerminated = false;
      await BlocProvider
          .of<LoginBloc>(context)
          .loginRepository
          .updateUser(freelancerDTOModel);
    }
  }



Future<BidModel> checkIfExistingBidBeforeStartingCall(UserDTOModel userDTOModel,BuildContext context,
    )async{
  BidModel bidModel;
  Map<bool,QueryDocumentSnapshot?> queryDocumentSnapshot=await BlocProvider.of<BidBloc>(context)
      .bidRepository.getBidsBetweenTwoUsers(BlocProvider.of<LoginBloc>(context)
      .userDTOModel
      .userId, userDTOModel.userId);
      if(queryDocumentSnapshot[true]!=null) {
        bidModel = BidModel.fromJson(
            queryDocumentSnapshot[true]!.data() as Map<String, dynamic>,
            queryDocumentSnapshot[true]!.id);

      }
      else{
        bidModel = new BidModel(
            createdAt: DateTime.now().toIso8601String(),
            isLongTerm: false,
            status: "pending",
            userId: BlocProvider.of<LoginBloc>(context)
                .userDTOModel
                .userId,
            freelancerId: userDTOModel.userId,
            companyId: userDTOModel.companyId,
            askedRate: userDTOModel.rateDetails.hourlyRate,
            acceptedRate: userDTOModel.rateDetails.hourlyRate,
            profileName: BlocProvider.of<LoginBloc>(context)
                .userDTOModel
                .personalDetails
                .displayName,
            clientName:
            userDTOModel.personalDetails.displayName,
            acceptedBy: "",
            bid: [],
            createdBy: BlocProvider.of<LoginBloc>(context)
                .userDTOModel
                .personalDetails
                .displayName,
            rejectedBy: "",
            finalUpdatedAt: DateTime.now().toIso8601String(),
            id: "");
      }
      return bidModel;

}