
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/model/date_filter.dart';

class CallsDashboardEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class FetchCallsMadeEvent extends CallsDashboardEvent{
  String userId;
  String associateName;
  String fieldTypeToBeSearched;
  int dateFilter;
  String userType;
  FetchCallsMadeEvent({required this.userId,
    required this.userType,this.associateName="",this.dateFilter=3,required this.fieldTypeToBeSearched});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}

class FetchUpcomingCallsMadeEvent extends CallsDashboardEvent{
  String userId;
  String associateName;
  String fieldTypeToBeSearched,callStatus;
  int dateFilter;
  String userType;
  FetchUpcomingCallsMadeEvent({this.callStatus="accepted",required this.userId,
    required this.userType,this.associateName="",this.dateFilter=3,required this.fieldTypeToBeSearched});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}