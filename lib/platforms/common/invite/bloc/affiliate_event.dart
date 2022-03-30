
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';

class AffiliateEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendAffiliateLinkEvent extends AffiliateEvent{
  String email,shareLink,senderName;
  String senderId;
  bool isResend;
  SendAffiliateLinkEvent({this.isResend=false,required this.senderId,
    required this.email,required this.senderName,required this.shareLink});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}