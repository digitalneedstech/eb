import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_event.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_state.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_message.dart';

import 'package:flutter_eb/platforms/common/bids/bloc/bid_updation_bloc/bid_updation_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_updation_bloc/bid_updation_state.dart' as update;
import 'package:flutter_eb/platforms/common/bids/widgets/shared/bid_freelance_info.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/shared/bid_message.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/home_nav/home_nav.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';
import './widgets/decider_widget/decider_widget.dart';
class BidDetailFreelancerPage extends StatelessWidget {
  String bidId, userIdOfBidder,freelancerId;
  BidDetailFreelancerPage({this.bidId="",required this.freelancerId, this.userIdOfBidder=""});
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    UserDTOModel user = BlocProvider.of<LoginBloc>(context).userDTOModel;
    BlocProvider.of<ProfileBloc>(context)
        .add(FetchUserProfileEvent(userId: userIdOfBidder));
    BlocProvider.of<BidBloc>(context).add(FetchBidInfoEvent(
        bidId: bidId,
        userId: freelancerId));
    return BlocListener<BidUpdationBloc,update.BidUpdationState>(
      listener: (context, state) {
        if(state is update.CreatedOrUpdatedBidState){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Thanks. Bid Details Have Been Updated"),
            backgroundColor: Colors.green,
          ));
          BlocProvider.of<BidBloc>(context).add(FetchBidInfoEvent(
              bidId: bidId,
              userId: freelancerId));
          BlocProvider.of<ProfileBloc>(context)
              .add(FetchUserProfileEvent(userId: userIdOfBidder));
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          title: Text("Bid Details"),
        ),
        body: Column(children: [
          BidInfoWidget(),
          BlocBuilder<BidBloc, BidState>(builder: (context, state) {
            if (state is BidInfoState) {
              if(state.bidModel.bid.isEmpty){
                return NoDataFound();
              }
              else {
                return Container(
                  margin: const EdgeInsets.all(20.0),
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.35,
                  child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white),
                      padding: const EdgeInsets.all(10.0),
                      child: ListView(shrinkWrap: true, children: [
                        ListView.builder(
                          physics: ClampingScrollPhysics(),
                          itemCount: state.bidModel.bid.length,
                          itemBuilder: (context, int index) {
                            BidMessageModel bidMessage =
                            state.bidModel.bid[index];
                            bool isFromOtherParty=true;
                            if(bidMessage.userId == user.userId || bidMessage.userId==state.bidModel.userId)
                              isFromOtherParty=false;
                            return Row(
                              mainAxisAlignment:
                              isFromOtherParty
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                BidMessage(
                                  isFromOtherParty:isFromOtherParty,
                                  bidMessage: bidMessage,
                                ),
                              ],
                            );
                          },
                          shrinkWrap: true,
                        ),
                        FreelancerBidDeciderWidget(bidId: bidId,
                          model: state.bidModel,user: user,)
                      ])),
                );
              }
            }
            else if (state is BidInfoInPopupState) {
              if(state.bidModel.id==""){
                return NoDataFound();
              }
              else {
                return Container(
                  margin: const EdgeInsets.all(20.0),
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.35,
                  child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white),
                      padding: const EdgeInsets.all(10.0),
                      child: ListView(shrinkWrap: true, children: [
                        ListView.builder(
                          physics: ClampingScrollPhysics(),
                          itemCount: state.bidModel.bid.length,
                          itemBuilder: (context, int index) {
                            BidMessageModel bidMessage =
                            state.bidModel.bid[index];
                            return Row(
                              mainAxisAlignment:
                              bidMessage.userId == user.userId
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                BidMessage(
                                  isFromOtherParty:
                                  bidMessage.userId == user.userId
                                      ? true
                                      : false,
                                  bidMessage: bidMessage,
                                ),
                              ],
                            );
                          },
                          shrinkWrap: true,
                        ),
                        FreelancerBidDeciderWidget(bidId: bidId,model: state.bidModel,user: user,)
                      ])),
                );
              }
            }
            //else if(state is LoadingBidState || state is LoadingBidInPopupState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Loading")],
                ),
              );
            //}
          })
        ]),
      ),
    );
  }
}