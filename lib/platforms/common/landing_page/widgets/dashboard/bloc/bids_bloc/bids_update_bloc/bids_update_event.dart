
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/model/date_filter.dart';

class BidsDashboardUpdateEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class UpdateBidEvent extends BidsDashboardUpdateEvent{
  String bidId,userId,freelancerId,type;
  UpdateBidEvent({required this.userId,required this.bidId,required this.freelancerId,required this.type});
  @override
  // TODO: implement props
  List<Object> get props => [];
}
