import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/scheduled_calls_bloc/scheduled_call_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/scheduled_calls_bloc/scheduled_call_state.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/model/date_filter.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/repo/landing_repo.dart';
import 'package:flutter_eb/platforms/common/login/data/login_repository.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
TODO- Update user model with required new model values instead of null
 */
class ScheduledCallsDashboardBloc extends Bloc<ScheduleDashboardEvent, ScheduledCallsDashboardState> {
  final LandingRepo landingRepo;
  final LoginRepository loginRepository;
  ScheduledCallsDashboardBloc(this.landingRepo,this.loginRepository) : super(ScheduledCallsDashboardLoadedState());
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
  Stream<ScheduledCallsDashboardState> mapEventToState(
      ScheduleDashboardEvent event,) async* {
    if (event is FetchScheduledCallsDashboardMadeEvent) {
      yield LoadingState();
      List<ScheduleRequest> bids=[];
      if(event.userType==Constants.CUSTOMER){
        QuerySnapshot snapshot=await loginRepository.getAcceptedResourcesList(event.userId);
        for(DocumentSnapshot doc in snapshot.docs){
          if(doc.exists) {
            Map<String,dynamic> data=doc.data() as Map<String,dynamic>;
            DocumentSnapshot docSnapshot=await loginRepository.getUserByUid(data["id"]);
            if(docSnapshot.exists) {
              if(event.callsType=="single") {
                QuerySnapshot snapshot = await getScheduledCallsList(
                    docSnapshot.id, event.isOnlyAcceptedCallsNeeded,associateName: event.associateName,
                    fieldTypeToBeSearched: event.fieldTypeToBeSearched);
                bids.addAll(snapshot.docs.map((e) =>
                    ScheduleRequest.fromJson(
                        e.data() as Map<String, dynamic>, e.id)).toList());
              }
              else{
                List<DocumentSnapshot> snapshot = await getScheduledCallsListForGroup(docSnapshot.id, event.isOnlyAcceptedCallsNeeded,associateName: event.associateName,
                    fieldTypeToBeSearched: event.fieldTypeToBeSearched);

                bids.addAll(snapshot.map((e) =>
                    ScheduleRequest.fromJson(
                        e.data() as Map<String, dynamic>, e.id)).toList());
              }

            }
          }
        }

      }
      else {
        if(event.callsType=="single") {
          QuerySnapshot snapshot = await getScheduledCallsList(event.userId,
              event.isOnlyAcceptedCallsNeeded,
              associateName: event.associateName,
              fieldTypeToBeSearched: event.fieldTypeToBeSearched);

          bids = snapshot.docs.map((e) =>
              ScheduleRequest.fromJson(e.data() as Map<String, dynamic>, e.id))
              .toList();
        }
        else{
          List<DocumentSnapshot> snapshot = await getScheduledCallsListForGroup(event.userId,
              event.isOnlyAcceptedCallsNeeded,
              associateName: event.associateName,
              fieldTypeToBeSearched: event.fieldTypeToBeSearched);

          bids = snapshot.map((e) =>
              ScheduleRequest.fromJson(e.data() as Map<String, dynamic>, e.id))
              .toList();
        }
      }
      yield ScheduledCallsDashboardMadeState(requests: bids);
    }

    if (event is FetchAllCallsDashboardMadeEvent) {
      yield LoadingState();
      if(event.userType==Constants.CUSTOMER){
        QuerySnapshot snapshot=await loginRepository.getAcceptedAffiliatesList(event.userId);
        List<DocumentSnapshot> totalCompanyPassedCalls=[];
        List<DocumentSnapshot> totalCompanyUpcomingCalls=[];
        for(DocumentSnapshot doc in snapshot.docs){
          QuerySnapshot snapshot = await landingRepo.getScheduledPassedCalls(
              doc.id, event.isOnlyAcceptedCallsNeeded);
          QuerySnapshot snapshotCalls = await landingRepo.getUpcomingCalls(
              doc.id,event.callStatus);
          totalCompanyPassedCalls.addAll(snapshot.docs);
          totalCompanyUpcomingCalls.addAll(snapshotCalls.docs);
        }
        yield AllCallsDashboardMadeState(requests: totalCompanyUpcomingCalls.length +
            totalCompanyPassedCalls.length,
            callsMadeCount: totalCompanyPassedCalls.length);
      }
      else {
        QuerySnapshot snapshot = await landingRepo.getScheduledPassedCalls(
            event.userId, event.isOnlyAcceptedCallsNeeded);
        QuerySnapshot snapshotCalls = await landingRepo.getUpcomingCalls(
            event.userId,event.callStatus);

        yield AllCallsDashboardMadeState(requests: snapshot.docs.length +
            snapshotCalls.docs.length,
            callsMadeCount: snapshot.docs.length);
      }
    }
  }

  Future<QuerySnapshot> getScheduledCallsList(String userId,bool isOnlyAcceptedCallsNeeded,
  {String associateName="",int dateFilter=3,String fieldTypeToBeSearched="Freelancer"}) async {
    return await this.landingRepo.getCalls(userId,isOnlyAcceptedCallsNeeded,associateName,dateFilter,fieldTypeToBeSearched);
  }

  Future<List<DocumentSnapshot>> getScheduledCallsListForGroup(String userId,bool isOnlyAcceptedCallsNeeded,
      {String associateName="",int dateFilter=3,String fieldTypeToBeSearched="Freelancer"}) async {
    return await this.landingRepo.getCallsForGroup(userId,isOnlyAcceptedCallsNeeded,associateName,dateFilter,fieldTypeToBeSearched);
  }

  Future<QuerySnapshot> getMadeCalls(String userId,[String associateName="",int dateFilter=3]) async {
    return await this.landingRepo.getMadeCalls(userId,associateName,dateFilter);
  }

  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }
}