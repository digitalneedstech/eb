import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';

@immutable
abstract class ContractsBidsState extends Equatable {}

class ContractsBidsLoadedState extends ContractsBidsState{
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
class ContractBidsMadeState extends ContractsBidsState {
  List<BidModel> bidModels;
  ContractBidsMadeState({required this.bidModels});
  @override
  List<Object> get props => [];
}

class LoadingState extends ContractsBidsState{
  @override
  // TODO: implement props
  @override
  List<Object> get props => [];
}