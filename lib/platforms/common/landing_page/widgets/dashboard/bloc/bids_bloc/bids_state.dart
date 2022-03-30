import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';

@immutable
abstract class BidsDashboardState extends Equatable {}
class BidsDashboardLoadedState extends BidsDashboardState {
  @override
  List<Object> get props => [];
}
class FetchBidsMadeState extends BidsDashboardState {
  List<BidModel> bidModels;
  FetchBidsMadeState({required this.bidModels});
  @override
  List<Object> get props => [];
}

class LoadingState extends BidsDashboardState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}