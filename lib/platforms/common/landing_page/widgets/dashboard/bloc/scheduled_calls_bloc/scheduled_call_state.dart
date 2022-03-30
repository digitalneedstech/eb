import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';

@immutable
abstract class ScheduledCallsDashboardState extends Equatable {}

class ScheduledCallsDashboardLoadedState extends ScheduledCallsDashboardState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ScheduledCallsDashboardMadeState extends ScheduledCallsDashboardState {
  List<ScheduleRequest> requests;
  ScheduledCallsDashboardMadeState({required this.requests});
  @override
  List<Object> get props => [];
}

class AllCallsDashboardMadeState extends ScheduledCallsDashboardState {
  int requests;
  int callsMadeCount;
  AllCallsDashboardMadeState({required this.callsMadeCount,required this.requests});
  @override
  List<Object> get props => [];
}
class LoadingState extends ScheduledCallsDashboardState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
