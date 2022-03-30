
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/model/date_filter.dart';

class BidsDashboardEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class FetchBidsMadeEvent extends BidsDashboardEvent{
  String userId;
  String associateName;
  String fieldTypeToBeSearched;
  int dateFilter;
  String userType;
  FetchBidsMadeEvent({required this.userId,required this.userType,
    this.associateName="",this.dateFilter=3,required this.fieldTypeToBeSearched});
  @override
  // TODO: implement props
  List<Object> get props => [];
}
