import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';

@immutable
abstract class LandingDashboardState extends Equatable {}

class LandingDashboardLoadedState extends LandingDashboardState{
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class CallsMadeState extends LandingDashboardState {
  List<ScheduleRequest> requests;
  CallsMadeState({required this.requests});
  @override
  List<Object> get props => [];
}

class ScheduledCallsMadeState extends LandingDashboardState {
  List<ScheduleRequest> requests;
  ScheduledCallsMadeState({required this.requests});
  @override
  List<Object> get props => [];
}

class BidsMadeState extends LandingDashboardState {
  List<BidModel> bidModels;
  BidsMadeState({required this.bidModels});
  @override
  List<Object> get props => [];
}

class ContractBidsMadeState extends LandingDashboardState {
  List<BidModel> bidModels;
  ContractBidsMadeState({required this.bidModels});
  @override
  List<Object> get props => [];
}

class LoadingState extends LandingDashboardState{
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class RoleUpdatedState extends LandingDashboardState{
  bool isUserRole;
  RoleUpdatedState({required this.isUserRole});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class CallsMadeForFreelancerState extends LandingDashboardState {
  List<ScheduleRequest> requests;
  CallsMadeForFreelancerState({required this.requests});
  @override
  List<Object> get props => [];
}

class ScheduledCallsMadeForFreelancerState extends LandingDashboardState {
  List<ScheduleRequest> requests;
  ScheduledCallsMadeForFreelancerState({required this.requests});
  @override
  List<Object> get props => [];
}

class BidsMadeForFreelancerState extends LandingDashboardState {
  List<BidModel> bidModels;
  BidsMadeForFreelancerState({required this.bidModels});
  @override
  List<Object> get props => [];
}

class ContractBidsMadeForFreelancerState extends LandingDashboardState {
  List<BidModel> bidModels;
  ContractBidsMadeForFreelancerState({required this.bidModels});
  @override
  List<Object> get props => [];
}
