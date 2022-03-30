
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/model/date_filter.dart';

class ContractsBidsEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class FetchContractBidsMadeEvent extends ContractsBidsEvent{
  String userId;
  String associateName;
  String fieldTypeToBeSearched;
  int dateFilter;
  String userType;
  FetchContractBidsMadeEvent({required this.userId,
    required this.userType,this.associateName="",this.dateFilter=3,required this.fieldTypeToBeSearched});
  @override
  // TODO: implement props
  List<Object> get props => [];
}
