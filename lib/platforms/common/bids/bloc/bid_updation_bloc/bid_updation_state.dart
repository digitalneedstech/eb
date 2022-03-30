import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';

@immutable
abstract class BidUpdationState extends Equatable {}
class BidUpdationStateUpdated extends BidUpdationState{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}
class CreatedOrUpdatedBidState extends BidUpdationState {
  @override
  List<Object> get props => [];
}

class LoadingBidOperationState extends BidUpdationState {
  @override
  List<Object> get props => [];
}
