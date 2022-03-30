import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_updation_bloc/bid_updation_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_updation_bloc/bid_updation_state.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_updation_bloc/bid_updation_event.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/bid_popup/bid_popup.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
class FreelancerBidDeciderWidget extends StatelessWidget{
  final BidModel model;
  final UserDTOModel user;
  final String bidId;
  FreelancerBidDeciderWidget({this.bidId="",required this.model,required this.user});
  @override
  Widget build(BuildContext context) {
    if(model.bid[model.bid.length-1].userId==model.userId && model.status=="pending") {
      return BlocBuilder<BidUpdationBloc,BidUpdationState>(
          builder:(context,state){
            if(state is LoadingBidOperationState){
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Updating")
                ],
              );
            }
            else{
              return Center(
                child: ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlineButton(
                        onPressed: () {
                          model.status = "rejected";

                          model.rejectedBy=model.freelancerId;
                          model.isRejected=true;
                          BlocProvider.of<BidUpdationBloc>(context).add(CreateOrUpdateBidEvent(
                              bidModel: model,
                              userId: model.userId,
                              freelancerId: model.freelancerId,isNewBid: false,
                              updatedBy: "freelancer"));
                        },
                        child: Center(
                          child: Text(
                            "Reject",
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
                    SizedBox(
                      width: 10.0,
                    ),
                    OutlineButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return BidPopup(
                                  callback: (){},
                                    companyId: user.companyId,
                                    status: "pending",
                                    bidId: bidId,
                                    model: user,
                                    bidderId: model.userId,
                                    freelancerId: model.freelancerId);
                              },
                              barrierDismissible: false);
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
                    SizedBox(
                      width: 10.0,
                    ),
                    OutlineButton(
                        onPressed: () {
                          model.status = "accepted";
                          model.acceptedRate=model.bid[model.bid.length-1].amount;
                          model.acceptedBy=model.freelancerId;
                          model.isAccepted=true;
                          BlocProvider.of<BidUpdationBloc>(context)
                              .add(CreateOrUpdateBidEvent(bidModel: model,
                              userId: model.userId,
                              freelancerId: model.freelancerId,isNewBid: false,updatedBy: "freelancer"));
                        },
                        child: Center(
                          child: Text(
                            "Accept",
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
                ),
              );            }
          }
      );
    }
    else if(model.bid[model.bid.length-1].userId==model.freelancerId && model.status=="pending") {
      return Text("Waiting for Client Response");
    }
    else if (model.status == "accepted")
      return Text("Bid Has Been Accepted", textAlign: TextAlign.center,);
    else if (model.status == "rejected")
      return Text("Bid Has Been Rejected", textAlign: TextAlign.center,);
    else {
      return Container();
    }
  }

}