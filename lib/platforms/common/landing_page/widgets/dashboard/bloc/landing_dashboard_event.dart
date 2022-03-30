
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/model/date_filter.dart';

class LandingDashboardEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RoleUpdationEvent extends LandingDashboardEvent{
  bool isUserRole;
  RoleUpdationEvent({required this.isUserRole});
}

class FetchCallsMadeEvent extends LandingDashboardEvent{
  String userId;
  String associateName;
  String fieldTypeToBeSearched;
  int dateFilter;
  FetchCallsMadeEvent({required this.userId,
    this.associateName="",this.dateFilter=3,required this.fieldTypeToBeSearched});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}


class FetchScheduledCallsMadeEvent extends LandingDashboardEvent{
  String userId;
  String associateName;
  String fieldTypeToBeSearched;
  int dateFilter;
  FetchScheduledCallsMadeEvent({required this.userId,this.associateName="",this.dateFilter=3,
    required this.fieldTypeToBeSearched});
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class FetchBidsMadeEvent extends LandingDashboardEvent{
  String userId;
  String associateName;
  String fieldTypeToBeSearched;
  int dateFilter;

  FetchBidsMadeEvent({required this.userId,this.associateName="",this.dateFilter=3,
    required this.fieldTypeToBeSearched});
  @override
  // TODO: implement props
  List<Object> get props => [];

}


class FetchContractBidsMadeEvent extends LandingDashboardEvent{
  String userId;
  String associateName;
  String fieldTypeToBeSearched;
  int dateFilter;
  FetchContractBidsMadeEvent({required this.userId,this.associateName="",this.dateFilter=3,
    required this.fieldTypeToBeSearched});
  @override
  // TODO: implement props
  List<Object> get props => [];
}
