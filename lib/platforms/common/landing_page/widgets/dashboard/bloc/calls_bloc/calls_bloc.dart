import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/calls_bloc/calls_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/calls_bloc/calls_state.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/repo/landing_repo.dart';
import 'package:flutter_eb/platforms/common/login/data/login_repository.dart';
import 'package:flutter_eb/platforms/common/schedule/models/call_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';
import 'package:flutter_eb/shared/constants/constants.dart';

/*
TODO- Update user model with required new model values instead of null
 */
class CallsDashboardBloc extends Bloc<CallsDashboardEvent, CallsDashboardState> {
  final LandingRepo landingRepo;
  final LoginRepository loginRepository;
  CallsDashboardBloc(this.landingRepo,this.loginRepository) : super(CallsDashboardLoadedState());
  TextEditingController _associateNameController=TextEditingController();
  List<String> dateFilters=["All","Last 7 Days","Last Month","Today"];
  int selectedFiter=0;

  TextEditingController get associateNameController => _associateNameController;

  set associateNameController(TextEditingController value) {
    _associateNameController = value;
  }

  bool _isUserRole=true;


  bool get isUserRole => _isUserRole;

  set isUserRole(bool value) {
    _isUserRole = value;
  }

  @override
  Stream<CallsDashboardState> mapEventToState(
      CallsDashboardEvent event,) async* {
    if (event is FetchUpcomingCallsMadeEvent) {
      yield LoadingState();
      List<CallModel> bids=[];
      if(event.userType==Constants.CUSTOMER){
        QuerySnapshot snapshot=await loginRepository.getAcceptedAffiliatesList(event.userId);
        for(DocumentSnapshot doc in snapshot.docs){
          QuerySnapshot snapshot = await getScheduledCallsList(
              event.userId,event.callStatus, event.associateName, event.dateFilter);
          bids.addAll(snapshot.docs.map((e) =>
              CallModel.fromMap(e.data() as Map<String,dynamic>, e.id)).toList());
        }
      }
      else {
        QuerySnapshot snapshot = await getScheduledCallsList(
            event.userId,"accepted", event.associateName, event.dateFilter);
        bids = snapshot.docs.map((e) =>
            CallModel.fromMap(e.data() as Map<String,dynamic>, e.id)).toList();
      }
      yield CallsMadeState(requests: bids);
    }

    if (event is FetchCallsMadeEvent) {
      yield LoadingState();
      List<CallModel> bids=[];
      if(event.userType==Constants.CUSTOMER){

        QuerySnapshot snapshot=await loginRepository.getAcceptedResourcesList(event.userId);
        for(DocumentSnapshot doc in snapshot.docs){
          if(doc.exists) {
            Map<String,dynamic> data=doc.data() as Map<String,dynamic>;
            DocumentSnapshot docSnapshot=await loginRepository.getUserByUid(data["id"]);
            if(docSnapshot.exists) {
              QuerySnapshot snapshot = await landingRepo.getMadeCalls(
                  docSnapshot.id, event.associateName, event.dateFilter);
              bids.addAll(snapshot.docs.map((e) =>
                  CallModel.fromMap(e.data() as Map<String,dynamic>, e.id)).toList());
            }
          }
        }

      }
      else {
        QuerySnapshot snapshot = await landingRepo.getMadeCalls(
            event.userId, event.associateName, event.dateFilter);
        bids = snapshot.docs.map((e) =>
            CallModel.fromMap(e.data() as Map<String,dynamic>, e.id)).toList();
      }
      yield CallsMadeState(requests: bids);
    }
  }



  Future<QuerySnapshot> getScheduledCallsList(String userId,String status,[String associateName="",int dateFilter=3]) async {
    return await this.landingRepo.getUpcomingCalls(userId,status,associateName,dateFilter);
  }

  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }
}