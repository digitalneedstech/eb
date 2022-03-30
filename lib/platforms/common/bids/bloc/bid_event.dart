
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';

class BidEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchBidListEvent extends BidEvent{
  String userId,userType;
  FetchBidListEvent({required this.userId,this.userType=""});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}

class SwitchBidTypeEvent extends BidEvent{
  bool bidType;
  SwitchBidTypeEvent({required this.bidType});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}

class FetchBidInfoEvent extends BidEvent{
  String bidId,userId;
  FetchBidInfoEvent({this.bidId="",this.userId=""});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}


class FetchBidInfoInPopUpEvent extends BidEvent{
  String bidId,userId;
  FetchBidInfoInPopUpEvent({this.bidId="",this.userId=""});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}

class ClearBidModel extends BidEvent{

}

class CreateOrUpdateBidEvent extends BidEvent{
  final BidModel bidModel;
  final String userId,freelancerId;
  final bool isNewBid;
  final String updatedBy;
  String? companyId;
  CreateOrUpdateBidEvent({this.companyId,required this.bidModel,
    this.updatedBy="",this.freelancerId="",this.userId="",this.isNewBid=true});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
