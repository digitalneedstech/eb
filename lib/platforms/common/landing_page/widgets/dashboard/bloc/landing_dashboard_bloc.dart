import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_state.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/model/date_filter.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/repo/landing_repo.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
TODO- Update user model with required new model values instead of null
 */
class LandingDashboardBloc extends Bloc<LandingDashboardEvent, LandingDashboardState> {
  final LandingRepo landingRepo;

  LandingDashboardBloc(this.landingRepo) : super(LandingDashboardLoadedState());
  TextEditingController _associateNameController=TextEditingController();
  List<String> dateFilters=["All","Last 7 Days","Last Month","Today"];
  List<String> postFilter=["All","Applied","Not Applied"];
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
  Stream<LandingDashboardState> mapEventToState(
      LandingDashboardEvent event,) async* {
    if (event is FetchBidsMadeEvent) {
      yield LoadingState();
      QuerySnapshot snapshot = await getBidsList(event.userId,event.associateName,event.dateFilter);
      List<BidModel> bids = snapshot.docs.map((e) =>
          BidModel.fromJson(e.data() as Map<String,dynamic>, e.id)).where((element) => element.status!="deleted").toList();
      yield BidsMadeState(bidModels: bids);
    }

    if (event is FetchContractBidsMadeEvent) {
      yield LoadingState();
      QuerySnapshot snapshot = await getBidsList(event.userId,event.associateName,event.dateFilter);
      List<BidModel> bids = snapshot.docs.map((e) =>
          BidModel.fromJson(e.data() as Map<String,dynamic>, e.id)).toList().where((element) => element.status!="deleted").toList();
      yield ContractBidsMadeState(bidModels: bids);
    }

    if (event is FetchCallsMadeEvent) {
      yield LoadingState();
      QuerySnapshot snapshot = await getScheduledCallsList(event.userId,event.associateName,event.dateFilter);
      List<ScheduleRequest> bids = snapshot.docs.map((e) =>
          ScheduleRequest.fromJson(e.data() as Map<String,dynamic>, e.id)).toList();
      yield CallsMadeState(requests: bids);
    }

    if (event is FetchScheduledCallsMadeEvent) {
      yield LoadingState();
      QuerySnapshot snapshot = await getScheduledCallsList(event.userId);
      List<ScheduleRequest> bids = snapshot.docs.map((e) =>
          ScheduleRequest.fromJson(e.data() as Map<String,dynamic>, e.id)).toList();
      yield ScheduledCallsMadeState(requests: bids);
    }
    if(event is RoleUpdationEvent){
      yield LoadingState();
      isUserRole=event.isUserRole;
      yield RoleUpdatedState(isUserRole: event.isUserRole);
    }
  }

  Future<QuerySnapshot> getBidsList(String userId,[String associateName="",int dateFilter=3]) async {
    return await this.landingRepo.getBids(userId,associateName,"",dateFilter);
  }

  Future<QuerySnapshot> getScheduledCallsList(String userId,[String associateName="",int dateFilter=3]) async {
    return await this.landingRepo.getCalls(userId,false,associateName,dateFilter);
  }


  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }
}