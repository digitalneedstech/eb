
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';

class BidUpdationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateOrUpdateBidEvent extends BidUpdationEvent{
  final BidModel bidModel;
  final String userId,freelancerId;
  final bool isNewBid;
  final String updatedBy;
  CreateOrUpdateBidEvent({required this.bidModel,
    this.updatedBy="",this.freelancerId="",this.userId="",this.isNewBid=true});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
