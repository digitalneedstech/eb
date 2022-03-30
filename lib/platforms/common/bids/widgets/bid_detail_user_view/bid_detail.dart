import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_event.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_state.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_message.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/shared/bid_decider.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/shared/bid_message.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/shared/bid_user_info_widget.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_state.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/eb_web_app_bar/eb_web_appbar.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';

class BidDetailPage extends StatelessWidget {
  //TODO- Pass freelancerId here to fetch the freelancer details to change the implementation
  String bidId;
  String freelancerId;
  BidDetailPage({this.bidId="",this.freelancerId=""});

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    UserDTOModel userDTOModel =
        BlocProvider.of<LoginBloc>(context).userDTOModel;
    BlocProvider.of<BidBloc>(context).add(FetchBidInfoEvent(
        bidId: bidId,
        userId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId));
    BlocProvider.of<ProfileBloc>(context)
        .add(FetchUserProfileEvent(userId: freelancerId));
    return BlocListener<BidBloc, BidState>(
      listener: (context, state) {
        if (state is LoadingBidState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Wait...")));
        }
        else if(state is CreatedOrUpdatedBidState){
          BlocProvider.of<BidBloc>(context).add(ClearBidModel());
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Thanks. Bid Details Have Been Updated"),
            backgroundColor: Colors.green,
          ));
          BlocProvider.of<BidBloc>(context).add(FetchBidInfoEvent(
              bidId: bidId,
              userId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId));
          BlocProvider.of<ProfileBloc>(context)
              .add(FetchUserProfileEvent(userId: freelancerId));
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey.shade300,
        appBar: getScreenWidth(context)>800 ?PreferredSize(
            preferredSize: Size.fromHeight(0.0), // here the desired height
            child: AppBar(
              automaticallyImplyLeading: false,
            )
        ): AppBar(
          title: Text("Bid Details"),
        ),
        body: Column(
          children: [

            getScreenWidth(context)>800?EbWebAppBarWidget():Container(),
            getScreenWidth(context)>800? SizedBox(height: 20.0,):Container(),
            BidUserInfoWidget(),
            getScreenWidth(context)>800? SizedBox(height: 20.0,):Container(),
            Expanded(
              child: BlocBuilder<BidBloc, BidState>(builder: (context, state) {
                if(state is LoadingBidOperationState){
                  return Center(child: Text("Processing"),);
                }
                if (state is LoadingBidState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("Loading")],
                    ),
                  );
                } else if (state is BidInfoState) {
                  return SingleChildScrollView(
                    child: Container(
                      margin: getScreenWidth(context)>800 ?EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width*0.1,
                      ):const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white),
                        padding: const EdgeInsets.all(10.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.builder(
                                physics: ClampingScrollPhysics(),
                                itemCount: state.bidModel.bid.length,
                                itemBuilder: (context, int index) {
                                  BidMessageModel bidMessage =
                                      state.bidModel.bid[index];
                                  return Row(
                                    mainAxisAlignment: bidMessage.userId ==
                                            userDTOModel.userId
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: [
                                      BidMessage(
                                        isFromOtherParty: bidMessage.userId ==
                                                userDTOModel.userId
                                            ? false
                                            : true,
                                        bidMessage: bidMessage,
                                      ),
                                    ],
                                  );
                                },
                                shrinkWrap: true,
                              ),
                              BidDeciderWidget(freelancerDTOModel: userDTOModel,
                                  bidId: bidId, model: state.bidModel)
                            ],
                          ),
                        )),
                  );
                } else if (state is BidInfoInPopupState) {
                  if (state.bidModel.id == "" || state.bidModel.bid.isEmpty) {
                    return NoDataFound();
                  } else {
                    return SingleChildScrollView(
                      child: Container(
                          margin: getScreenWidth(context)>800 ?EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width*0.1,
                          ):const EdgeInsets.all(20.0),
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
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ListView.builder(
                                  physics: ClampingScrollPhysics(),
                                  itemCount: state.bidModel.bid.length,
                                  itemBuilder: (context, int index) {
                                    BidMessageModel bidMessage =
                                        state.bidModel.bid[index];
                                    return Row(
                                      mainAxisAlignment: bidMessage.userId ==
                                              userDTOModel.userId
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: [
                                        BidMessage(
                                          isFromOtherParty: bidMessage.userId ==
                                                  userDTOModel.userId
                                              ? false
                                              : true,
                                          bidMessage: bidMessage,
                                        ),
                                      ],
                                    );
                                  },
                                  shrinkWrap: true,
                                ),
                                BlocBuilder<ProfileBloc, ProfileState>(
                                    builder: (context, profileState) {
                                      if (profileState is LoadingState) {
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [Text("Loading")],
                                          ),
                                        );
                                      } else if (profileState is FetchUserProfileState) {
                                        return BidDeciderWidget(
                                          freelancerDTOModel: profileState.userDTOModel,
                                            bidId: bidId, model: state.bidModel);

                                      }
                                      return Container();
                                    })

                              ],
                            ),
                          )),
                    );
                  }
                } /*else if (state is LoadingBidState ||
                    state is LoadingBidInPopupState) {*/
                  return Container();
                //}
              }),
            )
          ],
        ),
      ),
    );
  }
}
