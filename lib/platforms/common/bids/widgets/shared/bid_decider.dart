import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_event.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/bid_popup/bid_popup.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/schedule_call/schedule_call.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/call_model.dart';
import 'package:flutter_eb/platforms/common/schedule/schedule.dart';

class BidDeciderWidget extends StatelessWidget {
  BidModel model;
  UserDTOModel freelancerDTOModel;
  String bidId;
  BidDeciderWidget({required this.model,required this.freelancerDTOModel, this.bidId=""});
  @override
  Widget build(BuildContext context) {
    if (model.status == "pending") {
      if (model.bid[model.bid.length - 1].userId == model.userId)
        return Text("Waiting for ${model.clientName} Response");
      else if (model.bid[model.bid.length - 1].status == "pending" &&
          model.bid[model.bid.length - 1].userId == model.freelancerId)
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RaisedButton(
                  onPressed: () {
                    model.status = "accepted";
                    model.acceptedRate=model.bid[model.bid.length-1].amount;
                    model.acceptedBy=model.userId;
                    model.isAccepted=true;
                    //model.bid.add(BidMessageModel(status: 2,message: "Rejected",amount: "",createdAt: DateTime.now(),isLongTerm: model.bid[0].isLongTerm,uId: bidId));
                    BlocProvider.of<BidBloc>(context).add(
                        CreateOrUpdateBidEvent(
                          updatedBy: "user",
                            bidModel: model,
                            userId: model.userId,
                            freelancerId: model.freelancerId));
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SchedulePage(bidModel: model)),
                    );*/
                  },
                  child: Center(
                    child: Text("Accept The Bid"),
                  ),
                  color: Color(0xFF067EED),
                  textColor: Colors.white,
                ),
                SizedBox(
                  width: 20.0,
                ),
                OutlineButton(
                    onPressed: () {
                      BlocProvider.of<ProfileBloc>(context)
                          .loginRepository.getUserByUid(model.freelancerId)
                          .then((value) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return BidPopup(
                                callback: (){

                                },
                                  companyId: model.companyId,
                                bidId: bidId,
                                  model: UserDTOModel.fromJson(value.data() as Map<String,dynamic>,value.id),
                                  bidderId: BlocProvider.of<LoginBloc>(context)
                                      .userDTOModel.userId,
                                  freelancerId: model.freelancerId);
                            },
                            barrierDismissible: false);
                      });
                      //return Container();
                    },
                    child: Center(
                      child: Text(
                        "Negotiate",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    color: Colors.blue,
                    textColor: Colors.blue,
                    borderSide: BorderSide(
                      color: Colors.blue, //Color of the border
                      style: BorderStyle.solid, //Style of the border
                      width: 1, //width of the border
                    )),
              ],
            )
          ],
        );
    } else {
      if (model.status == "accepted")
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Hurray, ${model.acceptedBy == model.userId ? "You" : model.clientName} Has Accepepted Your Bid"),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RaisedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SchedulePage(bidModel: model,)),
                    );
                  },
                  child: Center(
                    child: Text("Schedule Call - ${model.acceptedRate} /hr"),
                  ),
                  color: Color(0xFF067EED),
                  textColor: Colors.white,
                ),
                SizedBox(
                  width: 20.0,
                ),
                OutlineButton(
                    onPressed:freelancerDTOModel.isOnline? () {
                      CallModel callModel = CallModel(
                            acceptedPrice: model.askedRate.toDouble(),
                            userId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId,
                            receiverId: [freelancerDTOModel.userId],
                            scheduleId: "",
                            receiverName: freelancerDTOModel.personalDetails
                                .displayName,
                            userName: BlocProvider.of<LoginBloc>(context).userDTOModel.personalDetails.displayName);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              ScheduleCall(callModel: callModel)),
                        );

                    }:null,
                    child: Center(
                      child: Text(
                        "Call Now",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    color: Colors.blue,
                    textColor: Colors.blue,
                    borderSide: BorderSide(
                      color: Colors.blue, //Color of the border
                      style: BorderStyle.solid, //Style of the border
                      width: 1, //width of the border
                    )),
              ],
            )
          ],
        );
      else if (model.status == "rejected")
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Unfortunately. ${model.clientName} has rejected  your Bid"),
            OutlineButton(
                onPressed: () {
                  BlocProvider.of<LoginBloc>(context)
                      .loginRepository
                      .getUserByUid(model.freelancerId)
                      .then(
                    (value) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return BidPopup(
                              companyId: model.companyId,
                              callback: (){},
                              model: UserDTOModel.fromJson(value.data() as Map<String,dynamic>,value.id),
                                bidderId: BlocProvider.of<LoginBloc>(context)
                                    .userDTOModel
                                    .userId,

                                freelancerId: model.freelancerId);
                          },
                          barrierDismissible: false);
                    },
                  );
                },
                child: Center(
                  child: Text(
                    "Offer New Bid",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                color: Colors.blue,
                textColor: Colors.blue,
                borderSide: BorderSide(
                  color: Colors.blue, //Color of the border
                  style: BorderStyle.solid, //Style of the border
                  width: 1, //width of the border
                )),
          ],
        );
    }
    return Container();
  }
}
