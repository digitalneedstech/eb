import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';

@immutable
abstract class AffiliateState extends Equatable {}
class AffiliateLoadedState extends AffiliateState {
  @override
  List<Object> get props => [];
}

class SendAffiliateLinkState extends AffiliateState {
  final bool isSent;
  final String? errorMessage;
  SendAffiliateLinkState({this.errorMessage,required this.isSent});
  @override
  List<Object> get props => [];
}

class SendAffiliateLinkInProgressState extends AffiliateState {
  @override
  List<Object> get props => [];
}
