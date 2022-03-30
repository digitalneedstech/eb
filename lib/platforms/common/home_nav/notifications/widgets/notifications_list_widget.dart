import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/bid_detail_freelancer_view/bid_detail_freelancer.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/bid_detail_user_view/bid_detail.dart';
import 'package:flutter_eb/platforms/common/home_nav/notifications/bloc/notification_bloc.dart';
import 'package:flutter_eb/platforms/common/home_nav/notifications/bloc/notification_event.dart';
import 'package:flutter_eb/platforms/common/home_nav/notifications/bloc/notification_state.dart';
import 'package:flutter_eb/platforms/common/home_nav/notifications/models/notification_model.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/animate_list/animate_list.dart';
import 'package:flutter_eb/shared/widgets/loading_shimmer/loading_shimmer.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
class NotificationsListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<NotificationBloc>(context).add(FetchNotifications(
        id: getUserDTOModelObject(context).userId));
    return BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
      if (state is LoadingNotificationsState) {
        return LoadingShimmerWidget();
      }
      if (state is FetchNotificationState) {
        if (state.notifications.isEmpty)
          return NoDataFound();
        else {
          return ListView.builder(
            itemBuilder: (context, int index) {
              NotificationModel notificationModel = state.notifications[index];
              return InkWell(
                onTap: (){
                  if(notificationModel.type=="bid"){
                    if(notificationModel.forKeyword=="freelancer"){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BidDetailFreelancerPage(
                            freelancerId: getUserDTOModelObject(context)
                                .userId,
                            bidId: notificationModel.refId,
                            userIdOfBidder: notificationModel.additionalId)),
                      );
                    }
                    else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            BidDetailPage(bidId: notificationModel.refId,
                            freelancerId: notificationModel.additionalId,)),
                      );
                    }
                  }
                },
                child: AnimateList(
                  index: index,
                  widget: Container(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 2.0),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade600,
                                    borderRadius: BorderRadius.circular(5.0)),
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                  child: Text(
                                    notificationModel.type,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            notificationModel.message,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              notificationModel.senderName,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            Text(
                              notificationModel.createdAt=="" ?"Not Dated" : notificationModel.createdAt,
                              style: TextStyle(color: Colors.grey.shade600),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: state.notifications.length,
            physics: BouncingScrollPhysics(),
          );
        }
      }
      return LoadingShimmerWidget();
    });
  }
}
