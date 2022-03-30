import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';

@immutable
abstract class BidState extends Equatable {}
class BidLoadedState extends BidState {
  @override
  List<Object> get props => [];
}
class BidInfoState extends BidState {
  BidModel bidModel;
  BidInfoState({required this.bidModel});
  @override
  List<Object> get props => [];
}

class SwitchBidState extends BidState {
  bool bidType;
  SwitchBidState({required this.bidType});
  @override
  List<Object> get props => [];
}

class BidInfoInPopupState extends BidState {
  BidModel bidModel;
  BidInfoInPopupState({required this.bidModel});
  @override
  List<Object> get props => [];
}

class BidListState extends BidState {
  List<BidModel> bidModels;
  BidListState({this.bidModels=const <BidModel>[]});
  @override
  List<Object> get props => [];
}

class CreatedOrUpdatedBidState extends BidState {
  @override
  List<Object> get props => [];
}

class LoadingBidState extends BidState {
  @override
  List<Object> get props => [];
}

class LoadingBidInPopupState extends BidState {
  @override
  List<Object> get props => [];
}



class LoadingBidOperationState extends BidState {
  @override
  List<Object> get props => [];
}
