import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';

@immutable
abstract class BidsDashboardUpdateState extends Equatable {}
class BidsDashboardUpdateLoadedState extends BidsDashboardUpdateState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class UpdateBidState extends BidsDashboardUpdateState{
  final bool isUpdated;
  UpdateBidState({required this.isUpdated});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class UpdateBidInProgressState extends BidsDashboardUpdateState{
  UpdateBidInProgressState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}
