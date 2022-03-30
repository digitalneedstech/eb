import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/call_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';

@immutable
abstract class CallsDashboardState extends Equatable {}
class CallsDashboardLoadedState extends CallsDashboardState{
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
class CallsMadeState extends CallsDashboardState {
  List<CallModel> requests;
  CallsMadeState({required this.requests});
  @override
  List<Object> get props => [];
}

class LoadingState extends CallsDashboardState{
  @override
  List<Object> get props => [];
}