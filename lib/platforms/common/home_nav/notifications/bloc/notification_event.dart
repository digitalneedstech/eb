
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';

class NotificationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchNotifications extends NotificationEvent{
  String id;
  FetchNotifications({required this.id});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}
