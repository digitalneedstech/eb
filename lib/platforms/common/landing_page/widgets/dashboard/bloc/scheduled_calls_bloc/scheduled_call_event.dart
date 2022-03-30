
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/model/date_filter.dart';

class ScheduleDashboardEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchScheduledCallsDashboardMadeEvent extends ScheduleDashboardEvent{
  String userId;
  String associateName;
  String fieldTypeToBeSearched;
  int dateFilter;
  String userType;
  final isOnlyAcceptedCallsNeeded;
  final String callsType;
  FetchScheduledCallsDashboardMadeEvent({this.callsType="single",
    required this.userId,this.isOnlyAcceptedCallsNeeded=false,
    required this.userType,this.associateName="",this.dateFilter=3,required this.fieldTypeToBeSearched});
  @override
  // TODO: implement props
  List<Object> get props => [];

}



class FetchAllCallsDashboardMadeEvent extends ScheduleDashboardEvent{
  String userId;
  String associateName;
  String fieldTypeToBeSearched,callStatus;
  int dateFilter;
  String userType;
  final isOnlyAcceptedCallsNeeded;
  FetchAllCallsDashboardMadeEvent({this.callStatus="accepted",this.isOnlyAcceptedCallsNeeded=false,required this.userId,
    required this.userType,this.associateName="",this.dateFilter=3,required this.fieldTypeToBeSearched});
  @override
  // TODO: implement props
  List<Object> get props => [];

}